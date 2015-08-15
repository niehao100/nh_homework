clc;clear;close all;
freq=[];time=[];A=[];
%freq 存储每段的基波与谐波频率
%time 存储每段音乐时长
%A    存储每段基波与谐波的振幅
for i=2:32
    [freq,time,A]=f_f(freq,time,['fmt (' num2str(i) ').wav'],A);
end

note=round(log2(freq(1,:)/220)*12);