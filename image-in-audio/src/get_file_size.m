function [ sz ] = get_file_size( file )

    fid = fopen(file);
 
    fseek(fid, 0, 1);
    sz = ftell(fid);
    
    fclose(fid);
end

