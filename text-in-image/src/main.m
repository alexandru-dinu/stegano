clear; clc;


% input_image = '../img/lena-big.png';
% output_image = '../img/stegano.png';
% input_text = '../text/lorem-ipsum.txt';

input_image = '../img/animal_farm.png';
output_image = '../img/stegano.png';
input_text = '../text/animal-farm.txt';


tic
embed(input_image, input_text, output_image);
toc

tic
text = extract(output_image);
toc

% save text to file
fid = fopen('../text/out_text.txt', 'wt');
fwrite(fid, text(1:end))
fclose(fid);