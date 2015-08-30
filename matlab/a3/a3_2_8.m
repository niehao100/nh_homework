clc;clear;close all;
load('hall.mat');
load('JpegCoeff.mat');
[m n]=size(hall_gray);
%把长宽扩至8的倍数；
M=ceil(m/8);N=ceil(n/8);
hall_gray=double(hall_gray);
if (M*8~=m)
hall_gray=[hall_gray hall_gray(:,n)*ones(1,(M*8-m))];
end
if (N*8~=n)
hall_gray=[hall_gray;ones((N*8-n),1)*hall_gray(m,:)];
end

R=zeros(64,M*N);
hall_gray=hall_gray-128;
for i=1:M
    for j=1:N
        R(:,i*N+j-N)=zigzag(dct2(hall_gray(i*8-7:i*8,j*8-7:j*8)));
    end
end
