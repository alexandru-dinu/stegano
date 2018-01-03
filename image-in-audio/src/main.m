clear; clc;

input_image = '../img/lena-eye-gs.png';
input_audio = '../audio/drum-loop.wav';
output_audio = '../audio/emb-drum-loop.wav';

embed(0, input_audio, input_image, output_audio);
image = extract(0, output_audio);

imshow(image);