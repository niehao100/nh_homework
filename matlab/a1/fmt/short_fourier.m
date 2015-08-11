[s Fs]=audioread('fmt.wav');
L=length(s);
NFFT=2^nextpow2(L)/64;
[S1,F1,T1,P1]=spectrogram(s,128,16,NFFT,Fs);
surf(T1,F1,sqrt(P1),'edgecolor','none'); axis tight;
xlabel('t/s');ylabel('f/Hz');zlabel('A');
t=(L/Fs)