function [ enc_wav_data ] = encrypt( key, wav_data, image_data )
%ENCRYPT Summary of this function goes here
%   Detailed explanation goes here

    % load image data
    [height, width] = size(image_data);
    image_flatten = reshape(image_data.', 1, []);

    % copy wav data
    enc_wav_data = wav_data;
    
    step = 1;

    for b = 1:(height * width)
        image_byte = de2bi(image_flatten(b), 8);

        % encode bytes
        for i = 1:8
            idx = (i - 1) * step + 1;

            wav_byte = de2bi(wav_data((8*(b-1)) + idx), 16);

            % lsb encoding
            wav_byte(1) = image_byte(i);

            enc_wav_data((8*(b-1)) + idx) = bi2de(wav_byte);
        end

    end
end

