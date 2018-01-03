function [ image ] = extract( key, emb_wav_file)
%Extract the bytes from the altered wav file and reconstruct the embedded
%image

    % read wav data
    [wav_header, wav_len, emb_wav_data] = read_wav(emb_wav_file);
    
    % read height and width
    height = emb_wav_data(1);
    width = emb_wav_data(2);

    % output image
    image = zeros(1, height * width);
    
    total_image_length = height * width;
    
    % reconstruct each byte of the embedded image
    for b = 1:total_image_length
        byte = zeros(1, 8);

        % for each bit of the current byte
        for i = 1:4
            idx = (8*(b-1)) + 1 + 2 + i;

            wav_byte = de2bi(emb_wav_data(idx), 16);
            
            % lsb
            byte(2*(i-1) + 1) = wav_byte(1);
            byte(2 * i) = wav_byte(9);
        end

        image(b) = bi2de(byte);
    end

    image = uint8(image);
    image = vec2mat(image, width);
end

