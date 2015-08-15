clear;clc;close all;
a1=1.3789;a2=-0.9506;
b=1;
n=0:99;
a=[1 -a1 -a2];
zplane(b,a);
title('pole/zero')
figure
freqz(b,a);
figure
impz(b,a,100);
h=filter(b,a,(n==0));
hold on;
plot(n,h,'r*');
legend('impz','filter');
