clear; clc;

image = imread('../img/out.png');

% convert to YCbCr color space
image_ycbcr = rgb2ycbcr(image);

cb = image_ycbcr(:, :, 2);

ls = liftwave('haar', 'Int2Int');
[LL, HL, LH, HH] = lwt2(double(cb), ls);

[HH_height, HH_width] = size(HH);
[HL_height, HL_width] = size(HL);

HH_flat = reshape(HH.', 1, []);
HL_flat = reshape(HL.', 1, []);

% store the number of chars as the first `size_length` bytes
size_length = 2;
char_count = bi2de(HH_flat(1:size_length * 8));

bin_text = zeros(char_count, 8);


HH_can_fit = length(HH_flat) / 8;
HH_limit = min(char_count + size_length, HH_can_fit);

for i = size_length + 1:HH_limit
    bin_text(i-size_length, :) = abs(HH_flat((i-1)*8+1:(i-1)*8+8));
end

% HH couldn't contain the entire text, also read from HL
rest = char_count + size_length - HH_can_fit;
if (rest > 0)
    for i = 1:rest
        bin_text(i-size_length+HH_limit, :) = abs(HL_flat((i-1)*8+1:(i-1)*8+8));
    end
end

% convert text from binary to ascii

text = char(bi2de(bin_text(:,:)))'

