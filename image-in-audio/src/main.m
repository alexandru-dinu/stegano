clear; clc;

input_image = '../img/lena-gs-2.png';
input_audio = '../audio/drum-loop.wav';
output_audio = '../audio/emb-drum-loop.wav';

image_data = imread(input_image);
[~, ~, wav_data] = read_wav(input_audio);
num_samples = length(audioread(input_audio));

% size in KB
wav_size = get_file_size(input_audio) / 1024;
img_size = get_file_size(input_image) / 1024;

img_data_len = numel(image_data);
wav_data_len = length(wav_data);

overwhelmed = (wav_data_len / 8) < img_data_len;

if (overwhelmed)
    disp('Image size is too large to be embedded!')
else
    tic
    embed(0, input_audio, input_image, output_audio);
    toc
    
    tic
    image = extract(0, output_audio);
    toc
    
    imshow(image);

    oa = audioread(input_audio);
    sa = audioread(output_audio);
    
    N1 = length(oa(:, 1));
    N2 = length(oa(:, 2));

    mse_1 = (sum((oa(:, 1) - sa(:, 1)) .^ 2)) / N1;
    mse_2 = (sum((oa(:, 2) - sa(:, 2)) .^ 2)) / N2;
    
    snr_1 = 10 * log10((sum(oa(:, 1) .^ 2) / N1) / mse_1);
    snr_2 = 10 * log10((sum(oa(:, 2) .^ 2) / N2) / mse_2);
end


