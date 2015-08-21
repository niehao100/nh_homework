clear;clc;
[R,Fs]=audioread('whalesong.wav');
L=size(R,1);
T=1/Fs;
NFFT=2^nextpow2(L);
fft=abs(fft(R)/NFFT*2);
 f_max=find(fft(1:NFFT/2)==max(fft));
% plot(fft);
t=((0:L-1)*T)';
% sig=cos(2*pi*f_max*t);
% sound(sig,Fs);
% pause(1);
% sound(R,Fs);
% [S,F,T,P]=spectrogram(R,256,192,NFFT,Fs);

f=1:L;
f_first=2120;%find(S(:,1)==max(S(:,1)));
f_last=2650;%find(S(:,255)==max(S(:,255)));
f_aver=2700;%find(S(:,128)==max(S(:,128)));
f(1:4000)=f_first+f(1:4000)*(f_aver-f_first)/4000;
f(4000:12000)=f_aver;
f(12000:L)=f_aver-(f(12000:L)-12000)*(f_aver-f_last)/(L-12000);

f1(1:L)=5350;
f2=1:L;
f2(1:12000)=10600;
f2(12000:L)=10600-(f2(12000:L)-12000)*(10600-10000)/(L-12000);
f=f';f1=f1';f2=f2';

y=1:L;
y(1:4000)=y(1:4000)/4000;
y(4000:12000)=1;
y(12000:L)=(L-y(12000:L))/(L-12000);
y=y';
sig=y.*(cos(2*pi*f.*t)+0.01*cos(2*pi*f1.*t)+0.01*cos(2*pi*f2.*t));
sound(sig,Fs);
pause(1);
sound(R,Fs);
