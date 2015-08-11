clc;clear;close all;
Fs=8000;
load guitar.mat;
tmp=resample(wave2proc,250,243);
t=(1:25)/(8000/243*250);
colors= hsv(10);
figure;
subplot(2,1,1)
for d=1:10
    plot(t,tmp((d-1)*25+1:d*25),'color',colors(d,:));
    hold on 
end

tmp=resample(realwave,250,243);
a=zeros(250,25);
for d=1:25
    a((0:9)*25+d,d)=1/10;
end
wavetoproc=tmp'*a;
plot(t,wavetoproc,'k');
wavetoproc=kron(ones(10,1),wavetoproc');
wavetoproc=resample(wavetoproc,243,250);
t=(1:243)/8000;

plot(t,wavetoproc,'r',t,wave2proc,'b:',t,realwave,'k--');

figure; 
%use demo fft of matlab 
y=repmat(wave2proc,100,1);
L=size(y);
NFFT=2^nextpow2(L(1));
Y=fft(y,NFFT)/L(1);
f= Fs/2*linspace(0,1,NFFT/2+1);
plot(f,2*abs(Y(1:NFFT/2+1)));
