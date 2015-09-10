clear;clc;close all;
img=imread('graygroundtruth.jpg');
[m,n]=size(img);

aver_row=mean(img,1);
aver_row=aver_row-mean(aver_row);
subplot(2,1,1)
plot((1:n),aver_row);
hold;
[t,omg,FT,IFT] = prefourier([0,n-1],n,[0,0.3],n);
F_row=FT*aver_row';
[value,index]=max(abs(F_row));
an=abs(angle(F_row(index)));
left=an/omg(index)
width=2*pi/omg(index)
plot((1:n),255*cos(omg(index)*(1:n)+an),'r');
subplot(2,1,2);
plot(omg,abs(F_row));
title('Fourier for average of rows')

figure
aver_column=mean(img,2);
aver_column=(aver_column-mean(aver_column))';
subplot(2,1,1)
plot((1:m),aver_column);
hold;
[t,omg,FT,IFT] = prefourier([0,m-1],m,[0,0.3],m);
F_column=FT*aver_column';
[value,index]=max(abs(F_column));
an=abs(angle(F_column(index)));
top=an/omg(index)
height=2*pi/omg(index)
plot((1:m),255*cos(omg(index)*(1:m)+an),'r');
subplot(2,1,2);
plot(omg,abs(F_column));
title('Fourier for average of rows')

figure
width=round(width);
height=round(height);
left=round(left);
top=round(top);
c_count=fix((n-left)/width);
r_count=fix((m-top)/height);
imshow(img);
hold on;
for i=0:r_count
    plot(left:left+c_count*width,top+height*i,'r');
end
hold on;
for i=0:c_count
    plot(left+width*i,top:top+height*r_count,'r');
end

figure
pic=zeros(height,width,r_count*c_count);
for i=1:r_count
    for j=1:c_count
        subplot(r_count,c_count,j+i*c_count-c_count);
        pic(:,:,j+(i-1)*c_count)=img((top+height*(i-1)):top+height*i-1,left+width*(j-1):left+width*j-1);
        imshow(uint8(pic(:,:,j+(i-1)*c_count)));
    end
end
save graygroundturth
