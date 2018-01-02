clear;
clc;

% load image data
image = imread('../img/img1-smaller.png');
[height, width] = size(image);
image_flatten = reshape(image.', 1, []);

% load wav data
[wav_header, wav_len, wav_data] = read_wav('../sound/drum-loop.wav');

enc_wav_data = encrypt(0, wav_data, image);

write_wav(wav_header, wav_len, enc_wav_data, '../sound/drum-loop-enc.wav');

img = decrypt(0, enc_wav_data, height, width);

imshow(img);