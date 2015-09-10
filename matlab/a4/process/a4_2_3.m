clear;clc;close all;

load 'graycapture.mat';

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
mesh(high_pass_2);

pic_div=zeros(height,width,r_count*c_count);
for i=1:r_count*c_count
    pic_div(:,:,i)=conv2(pic(:,:,i)-128,high_pass_2,'same');
 %   subplot(r_count,c_count,i);
 %   imshow(uint8(128+pic_div(:,:,i)));
end

corr=zeros(r_count*c_count,c_count*r_count);
size=r_count*c_count;
for i=1:size
    for j=i+1:size
        corr(j,i)=max(max(normxcorr2(pic_div(:,:,i),pic_div(:,:,j))));
    end
end

siz=r_count*c_count;
corr_tmp=reshape(corr,[],1);
[value,index]=sort(corr_tmp,'descend');
for i=1:10
a=fix((index(i)-1)/siz)+1;
b=mod(index(i)-1,siz)+1;
subplot(2,10,i);
imshow(uint8(pic(:,:,a)));
title(value(i))
subplot(2,10,i+10);
imshow(uint8(pic(:,:,b)));
end
%人工筛选得到
figure
%no_e=[83 101 106 109 112 118 122 132 134 135];
no_e=[136 156 171 179 180 171 184 186 188 189];
for i=1:10
a=fix((index(no_e(i))-1)/siz)+1;
b=mod(index(no_e(i))-1,siz)+1;
subplot(2,10,i);
imshow(uint8(pic(:,:,a)));
title(value(no_e(i)))
subplot(2,10,i+10);
imshow(uint8(pic(:,:,b)));
end
save corr_capture.mat 