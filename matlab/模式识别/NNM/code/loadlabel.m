function [ label ] = loadlabel (filename,lsize)
fp = fopen(filename,'rb');
magic=fread(fp,1,'int32',0,'ieee-be');
nlabels = fread(fp, 1, 'int32', 0, 'ieee-be');
label = fread(fp, lsize, 'unsigned char');  
fclose(fp);
%label=label(1:lsize);
end

