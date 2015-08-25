clear;clc;close all;
load('hall.mat');
in=hall_gray;
subplot(2,2,1);
imshow(in);
title('Origin');
C=dct2(in);
[m,n]=size(in);
C_tran=C';
C_90=rot90(C);
C_180=rot90(C_90);
subplot(2,2,2)
imshow(uint8(idct2(C_tran)));
title('transpose');
subplot(2,2,3)
imshow(uint8(idct2(C_90)));
title('Rot 90^{\circ}');
subplot(2,2,4);
imshow(uint8(idct2(C_180)));
title('Rot 180^{\circ}');
