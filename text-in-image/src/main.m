input_image = '../img/alpine.png';
output_image = '../img/alpine_emb.png';
input_text = '../text/sublime-license.txt';

embed(input_image, input_text, output_image);

text = extract(output_image);