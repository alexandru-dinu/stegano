clear; clc;

% read image (carrier)
image = imread('../img/img1.png');

%{
figure
imshow(image);
title('original image');
%}

% read text (secret)
% each char is 8-bits long
fid = fopen('../text/sublime-license.txt', 'rb');
text = fread(fid, inf, 'uint8');
bin_text = de2bi(text, 8);

char_count = length(bin_text);

% convert to YCbCr color space
image_ycbcr = rgb2ycbcr(image);

cb = image_ycbcr(:, :, 2);

ls = liftwave('haar', 'Int2Int');

% image DWT
[LL, HL, LH, HH] = lwt2(double(cb), ls);

% Hide text in HH and HL regions
[HH_height, HH_width] = size(HH);
[HL_height, HL_width] = size(HL);

HH_flat = reshape(HH.', 1, []);
HL_flat = reshape(HL.', 1, []);

text_limit = (length(HH_flat) + length(HL_flat) - 16) / 8;
disp(text_limit);

overwhelmed = (8 * char_count + 2) > (length(HH_flat) + length(HL_flat));

if (overwhelmed)
    disp("Text length is too large to be embedded!");
else
    % store the number of chars as the first `size_length` bytes
    size_length = 2;
    HH_flat(1:size_length * 8) = de2bi(char_count, size_length * 8);
    
    HH_can_fit = length(HH_flat) / 8;
   
    HH_limit = min(char_count + size_length, HH_can_fit);
    
    % encode in HH (first 2 bytes = size)
    for i = size_length + 1:HH_limit
        HH_flat((i-1)*8+1:(i-1)*8+8) = bin_text(i-size_length, :);
    end
    
    % if HH can't contain all, also use HL
    rest = char_count + size_length - HH_can_fit;
    if (rest > 0)
        for i = 1:rest
            HL_flat((i-1)*8+1:(i-1)*8+8) = bin_text(i-size_length+HH_limit, :);
        end
    end
end

% restore matrix dimensions
HH = vec2mat(HH_flat, HH_width);
HL = vec2mat(HL_flat, HL_width);

% output final image
image_ycbcr(:, :, 2) = ilwt2(LL, HL, LH, HH, ls);
out_image = ycbcr2rgb(image_ycbcr);
imwrite(out_image, '../img/out.png');

%{
figure
imshow(out_image);
title('stegano image');
%}