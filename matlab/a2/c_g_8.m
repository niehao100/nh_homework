clear;close all;clc;
x=zeros(1,8000);
i=1;
while i<8000
    x(i)=1;
    i=i+ 80 + 5*mod(fix(i/80),50);
end
hold on;
b=1;a1=1.3789;a2=-0.9506;
a=[1 -a1 -a2];
s=filter(b,a,x);
plot(s);
sound(s,8000);



