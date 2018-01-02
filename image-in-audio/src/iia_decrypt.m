function [ img ] = decrypt( key, enc_wav_data, height, width)
%DECRYPT Summary of this function goes here
%   Detailed explanation goes here

    img = zeros(1, height * width);
   
    step = 1;
    
    for b = 1:(height * width)
        byte = zeros(1, 8);

        for i = 1:8
            idx = (i - 1) * step + 1;

            wav_byte = de2bi(enc_wav_data((8*(b-1)) + idx), 16);

            byte(i) = wav_byte(1);
        end

        img(b) = bi2de(byte);
    end

    img = uint8(img);
    img = vec2mat(img, width);
end

