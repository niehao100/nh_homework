clear;clc;clear all;
%tone 中
%1~7 与简谱一致
tone=[13 12.5 13 12.5 13 7 12 11 6 -10 1 3 6 7 -10 3 11 7 6];
time=[0.25 0.25 0.25 0.25 0.25 0.25 0.25 0.25 0.5 0.25 0.25 0.25 0.25 0.5 0.25 0.25 0.25 0.25 0.5];
%谱子转十二平均律
msheet2tone=[-3 -4 -4.5 -5 -5.5 -6 -6.5 -7 1 1.5 2 2.5 3 4 4.5 5 5.5 6 6.5 7 11 11.5 12 12.5 13];
for i=1:length(tone)
    [~,num]=find(msheet2tone==tone(i));
    if isempty(num)
        num=-4;
    end
    tone(i)=num;
end
s=[];
%演奏
for i=1:length(tone)
    s=[s;m_note_3(tone(i)-6,time(i),220,8000)];
end
sound(s,8000);
