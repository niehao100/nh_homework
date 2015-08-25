clear;clc;close all;
load('hall.mat');
in=hall_gray;
subplot(1,3,1);
imshow(in);
title('Origin');
C=dct2(in);
[m,n]=size(in);
%左侧
C_l=C;C_l(:,(1:4))=0;
%右侧
C_r=C;C_r(:,(n-3:n))=0;
subplot(1,3,2)
imshow(uint8(idct2(C_l)));
title('Left to zero');
subplot(1,3,3);
imshow(uint8(idct2(C_r)));
title('Right to zero');
