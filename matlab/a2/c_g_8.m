clear;close all;clc;
x=zeros(1,8000);
i=1;
while i<8000
    x(i)=1;
    i=i+ 80 + 5*mod(fix(i/80),50);
end
stem(x);
sound(x,8000);



