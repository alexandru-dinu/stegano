function [ ] = embed( key, input_wav_file, input_image_file, output_wav_file)
%Embed each byte of the wav file into the image file. Each bit of the image
%is embedded into one byte of the audio.

    % load image data
    image = imread(input_image_file);
    [height, width] = size(image);
    image_flatten = reshape(image.', 1, []);
    
    total_image_length = height * width;

    % read wav data
    [wav_header, wav_len, wav_data] = read_wav(input_wav_file);
    
    emb_wav_data = wav_data;
   
    emb_wav_data(1) = height;
    emb_wav_data(2) = width;

    % for each byte of the image
    for b = 1:total_image_length
        % get current image byte
        image_byte = de2bi(image_flatten(b), 8);

        % encode current image byte bit-by-bit
        for i = 1:4
            idx = (8*(b-1)) + 1 + 2 + i;

            % get current wav 2-byte chunk
            wav_byte = de2bi(emb_wav_data(idx), 16);

            % lsb encoding
            wav_byte(1) = image_byte(2*(i-1) + 1);
            wav_byte(9) = image_byte(2 * i);

            emb_wav_data(idx) = bi2de(wav_byte);
        end
    end
    
    % write the altered wav file
    write_wav(wav_header, wav_len, emb_wav_data, output_wav_file);
end

