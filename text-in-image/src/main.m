clear; clc;

input_image = '../img/lena.png';
output_image = '../img/emb_lena.png';
input_text = '../text/lorem-ipsum.txt';

tic
embed(input_image, input_text, output_image);
toc

tic
text = extract(output_image);
toc