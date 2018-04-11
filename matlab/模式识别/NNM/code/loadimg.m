function [ images ] = loadimg (filename,imsize)
fp = fopen(filename,'rb');
magic=fread(fp,1,'int32',0,'ieee-be');
nimg=fread(fp,1,'int32',0,'ieee-be');
Row=fread(fp,1,'int32',0,'ieee-be');
Col=fread(fp,1,'int32',0,'ieee-be');

images=fread(fp,Col*Row*imsize,'unsigned char');
images = reshape(images, Col, Row, imsize);
images = permute(images,[2 1 3]);%roate
fclose(fp);
%images=reshape(images,Col*Row,imsize);
end

