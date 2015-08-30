function [R,M,N]=quan(to_process)
%将矩阵量化
load('JpegCoeff.mat');
[m,n]=size(to_process);
M=ceil(m/8);N=ceil(n/8);
%转化为double以进行计算
to_process=double(to_process);
%长宽扩至8的倍数
if (M*8~=m)
    to_process=[to_process to_process(:,n)*ones(1,(M*8-m))];
end
if (N*8~=n)
    to_process=[to_process;ones((N*8-n),1)*to_process(m,:)];
end
m=8*M;
n=8*N;
%C存储DCT基数，R存储zig-tag变换后的值
to_process=to_process-128;
C=to_process;
R=zeros(64,M*N);
for i=1:M
    for j=1:N
        %量化
        C(i*8-7:i*8,j*8-7:j*8)=round(dct2(to_process(i*8-7:i*8,j*8-7:j*8))./QTAB);
        %zig-zag
        R(:,i*N-N+j)=zigzag(C(i*8-7:i*8,j*8-7:j*8));
    end
end
return;
