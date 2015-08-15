clc;clear;close all;
Fs=8000;
load guitar.mat;
tmp=resample(realwave,250,243);
a=zeros(250,25);
for d=1:25
    a((0:9)*25+d,d)=1/10;
end
wavetoproc=tmp'*a;
wavetoproc=kron(ones(10,1),wavetoproc');
wavetoproc=resample(wavetoproc,243,250);
t=(1:243)/8000;
plot(t,wave2proc,'LineWidth',3);
hold on;
plot(t,wavetoproc,'r');
legend('wave2proc','waveget')