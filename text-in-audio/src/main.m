clear; clc;

% encoding scheme:
% first 2 values are zero_value and one_value
% afterwards, in steps of 2, look for those values and extract the bits

[wav_header, wav_len, wav_data] = read_wav('../audio/drum-loop-mono.wav');

% read text (secret to be sent)
% each char is 8-bits long
fid = fopen('../text/sublime-license.txt', 'rb');
text = fread(fid, inf, 'uint8');
bin_text = de2bi(text, 8);

char_count = length(bin_text);

haar_wavelet = liftwave('haar', 'Int2Int');

[cApprox, cDetail] = lwt(double(wav_data), haar_wavelet);

% tweak this settings
% zero_value = mean(cDetail(cDetail > -2 & cDetail < 0));
% one_value = mean(cDetail(cDetail > 0 & cDetail < 2));

out_cDetail = cDetail;

% embed the encoding scheme used
out_cDetail(1) = zero_value;
out_cDetail(2) = one_value;

enc_char_count = de2bi(char_count, 16);
enc_char_count(enc_char_count == 0) = zero_value;
enc_char_count(enc_char_count == 1) = one_value;

% embed the size of the text
out_cDetail(3:18) = enc_char_count;


% encode only using even positions 
% -18 because the first 2 values are reserved for the encoding of 0/1
% and the next 16 are reserved for storing the char count
cD_can_fit = (length(out_cDetail) / 2 / 8 - 18);


% embed the text
for i = 1:length(bin_text)
    idx = (((i-1) * 8 + 1):(i * 8)) * 2 + 18;
    
    text_byte = bin_text(i, :);
    text_byte(text_byte == 0) = zero_value;
    text_byte(text_byte == 1) = one_value;
    
    out_cDetail(idx) = text_byte;
end

y = ilwt(cApprox, out_cDetail, haar_wavelet);
write_wav(wav_header, wav_len, y, '../audio/emb-drum-loop.wav');




%%% extract
haar_wavelet = liftwave('haar', 'Int2Int');

[wav_header, wav_len, wav_data] = read_wav('../audio/emb-drum-loop.wav');
[ca, cd] = lwt(double(wav_data), haar_wavelet);


char_count = cd(3:18);
char_count(char_count < 0) = 0;
char_count(char_count > 0) = 1;
char_count = bi2de(char_count');

% extract the text
bin_text = zeros(char_count, 8);

for i = 1:char_count
    idx = (((i-1) * 8 + 1):(i * 8)) * 2 + 18;
    
    enc_byte = cd(idx)';
    enc_byte(enc_byte < 0) = 0;
    enc_byte(enc_byte > 0) = 1;
   
    bin_text(i, :) = enc_byte;
end

text = char(bi2de(bin_text(:,:)))';
