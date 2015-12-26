clear;clc;close all;
img=imread('graygroundtruth.jpg');
%利用高通滤波器进行处理
high_pass_1=fir1(22,0.5,'high');
[imp,n]=impz(high_pass_1);
stem(n,imp);
len=length(imp);
[~,max_i]=max(imp);
tmp_r=repmat(1:len,len,1)-max_i;
tmp_c=repmat((1:len)',1,len)-max_i;
tmp=round(sqrt(tmp_r.^2+tmp_c.^2));
t_i=find(tmp>len/2);
tmp(t_i)=max_i-1;
high_pass_2=imp(max_i-tmp);
figure;
img_div=conv2(img-128,high_pass_2,'same');
%行处理
[m,n]=size(img);
aver_row=mean(img_div,1);
aver_row=aver_row-mean(aver_row);
subplot(2,1,1)
plot((1:n),aver_row);
hold;
L=length(aver_row);
NFFT=2^nextpow2(L);
F_row=fft(aver_row,NFFT)/L;
nf=NFFT/2+1;
f= 1/2*linspace(0,1,nf);
reso=1/2/nf;
[value,index]=max(abs(F_row(f<0.02)));
an=angle(F_row(index));
left=(pi-an)/2/pi/f(index)
width=1/f(index)
plot((1:n),255*cos(2*pi*f(index)*(1:n)+an),'r');
subplot(2,1,2);
plot(f(f<0.02),abs(F_row(f<0.02)));
title('Fourier for average of rows')
%列处理
figure
aver_column=mean(img_div,2);
aver_column=aver_column-mean(aver_column);
subplot(2,1,1)
plot((1:m),aver_column);
hold;
L=length(aver_column);
NFFT=2^nextpow2(L);
F_column=fft(aver_column,NFFT)/L;
nf=NFFT/2+1;
f= 1/2*linspace(0,1,nf);
reso=1/2/nf;
[value,index]=max(abs(F_column(f<0.02)));
an=angle(F_column(index));
top=(pi-an)/2/pi/f(index)
height=1/f(index)
plot((1:m),255*cos(2*pi*f(index)*(1:m)+an),'r');
subplot(2,1,2);
plot(f(f<0.02),abs(F_column(f<0.02)));
title('Fourier for average of columns')

figure

width=round(width);
height=round(height);
top=round(top);
left=round(left);
c_count=fix((n-left)/width);
r_count=fix((m-top)/height);
imshow(img);
hold on;
%用红线分割
for i=0:r_count
    plot(left:left+c_count*width,top+height*i,'r');
end
hold on;
for i=0:c_count
    plot(left+width*i,top:top+height*r_count,'r');
end
%切割
figure
pic=zeros(height,width,r_count*c_count);
for i=1:r_count
    for j=1:c_count
        subplot(r_count,c_count,j+i*c_count-c_count);
        pic(:,:,j+(i-1)*c_count)=img((top+height*(i-1)):top+height*i-1,left+width*(j-1):left+width*j-1);
        imshow(uint8(pic(:,:,j+(i-1)*c_count)));
    end
end
save graygroundtruth
