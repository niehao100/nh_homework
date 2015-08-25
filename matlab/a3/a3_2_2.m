clc;clear;close all;
load('hall.mat');
in=repmat(hall_gray,10,10)-128;
profile on;
s1=dct2(in);
s2=my_dct2(in);
profile viewer;
e=imabsdiff(s1,s2)
