load('guitar.mat');
R1=wave2proc;
R2=realwave;
Fs=8000;
L=length(R1);
NFFT=2^nextpow2(L);
Y1=fft(R1,NFFT)/L;
Y2=fft(R2,NFFT)/L;
nf=NFFT/2+1;
f= Fs/2*linspace(0,1,nf);
plot(f,2*abs(Y1(1:nf)),'b',f,2*abs(Y2(1:nf)),'r');
legend('wave2proc','realwave');

