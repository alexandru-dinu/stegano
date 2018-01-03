function [ ] = write_wav( header, len, data, wav_file )
    out = fopen(wav_file, 'w');
    
    fwrite(out, header, 'uint8');
    fwrite(out, len, 'uint32');
    fwrite(out, data, 'uint16');
    
    fclose(out);
end

