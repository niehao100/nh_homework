%# -*- coding: gb2312 -*-
clear;clc;close all;
a1=1.3789;a2=-0.9506;
b=1;
n=0:99;
a=[1 -a1 -a2];
[z,p,k]=tf2zp(b,a);
%角度为正频率加155
%为负减155
p=p.*exp(2*pi/8000*150*  (2* (angle(p)>0) -1) *1j);
[b,a]=zp2tf(z,p,k)
