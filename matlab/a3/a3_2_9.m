clc;clear;close all;
load('hall.mat');
load('JpegCoeff.mat');
[m,n]=size(hall_gray);
%量化矩阵为MxN
M=ceil(m/8);N=ceil(n/8);
%转化为double以进行计算
hall_gray=double(hall_gray);
%长宽扩至8的倍数
if (M*8~=m)
    hall_gray=[hall_gray hall_gray(:,n)*ones(1,(M*8-m))];
end
if (N*8~=n)
    hall_gray=[hall_gray;ones((N*8-n),1)*hall_gray(m,:)];
end
%C存储DCT基数，R存储zig-tag变换后的值
hall_gray=hall_gray-128;
C=hall_gray;
R=zeros(64,M*N);
for i=1:M
    for j=1:N
        %量化
        C(i*8-7:i*8,j*8-7:j*8)=round(dct2(hall_gray(i*8-7:i*8,j*8-7:j*8))./QTAB);
        %zig-zag
        R(:,i*N-N+j)=zigzag(C(i*8-7:i*8,j*8-7:j*8));
    end
end
%DC部分
%差分编码
ERR_DC=[2*R(1,1) R(1,1:N*M-1)]-R(1,:);
%DC部分的编码
DCstream=logical([]);
ACstream=logical([]);
Category_DC=ceil(log2(abs(ERR_DC)+1));
Size_AC=ceil(log2(abs(R)+1));
%AC部分
zero16=[1 1 1 1 1 1 1 1 0 0 1];
for i=1:M*N
    DCstream=[DCstream DCTAB(Category_DC(i)+1,2:1+DCTAB(Category_DC(i)+1,1))];
    if ERR_DC(i)>=0;%减48是因为0的asscii码
        DCstream=[DCstream dec2bin(ERR_DC(i))-48];
    else%一补码
        DCstream=[DCstream ~(dec2bin(-ERR_DC(i))-48)];
    end
    AC_NONE_ZERO=[1;1+find(R(2:64,i))];
    if size(AC_NONE_ZERO~=1)
        for k=2:length(AC_NONE_ZERO)
            count0=AC_NONE_ZERO(k)-AC_NONE_ZERO(k-1)-1;
            while count0>15
                ACstream=[ACstream zero16];
                count0=count0-16;
            end
            ACstream=[ACstream  ACTAB((count0*10+Size_AC(AC_NONE_ZERO(k),i)),4:(3+ACTAB(count0*10+Size_AC(AC_NONE_ZERO(k),i),3)))];
            if R(AC_NONE_ZERO(k),i)>=0;%减48是因为0的asscii码
                ACstream=[ACstream dec2bin(abs(R(AC_NONE_ZERO(k),i)))-48];
            else%一补码
                ACstream=[ACstream ~(dec2bin(abs(R(AC_NONE_ZERO(k),i)))-48)];
            end
        end
    end
    ACstream=[ACstream 1 0 1 0]; 
end
