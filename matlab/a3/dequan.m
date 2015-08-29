function [pic]=dequan(source,m,n,origin)
%%%source为dehaff后的数据
%%%m n 长宽
%%%origin 原图

load('JpegCoeff');
%pic为最终数据
pic=zeros(m,n);
M=ceil(m/8);N=ceil(n/8);
for i=1:M
    for j=1:N
        %反zigzag与拼接
        pic(i*8-7:i*8,j*8-7:j*8)=izigzag(source(:,i*N-N+j));
        %拼接与反dct
        pic(i*8-7:i*8,j*8-7:j*8)=idct2(pic(i*8-7:i*8,j*8-7:j*8).*QTAB)+128;
    end
end
pic=uint8(pic);
imshow(pic);
title('decode');

MSR=1/(m*n)*sum(sum((pic-origin).^2));
PSNR=10*log10(255^2/MSR)
