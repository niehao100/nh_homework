clc;clear;close all;
load('hall.mat');
in=hall_gray(61:68,81:88);
s1=dct2(in-128);
s2=dct2(in)-dct2(128*ones(size(in)));
e=imabsdiff(s1,s2)
