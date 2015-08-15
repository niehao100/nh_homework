clear;clc;
Fs=8000;
load guitar.mat;
y=repmat(wave2proc,100,1);
L=length(y);
NFFT=2^nextpow2(L);
Y=fft(y,NFFT)/L;
nf=NFFT/2+1;
f= Fs/2*linspace(0,1,nf);
reso=Fs/2/nf;
Y=2*abs(Y(1:nf)');
plot(f,Y);
xlabel('f/Hz');
Y1=zeros(2,nf);
Y1(1,2:nf)=Y(1:nf-1);
Y1(2,1:nf-1)=Y(2:nf);
Y1=(Y1-[Y;Y]);
Y1=[1 1]*(Y1<0);
Y1=(Y1==2);
f=f.*Y1;

if (max(Y.*Y1))>0.03
    f=f.*((Y.*Y1)>0.03);
else 
    f=f.*((Y.*Y1)>0.013);
end

[list,I]=sort(f+10000.*(f==0));
base=(1:6)*list(1);
a=zeros(1,6);
a(1)=Y(I(1));
for n=2:6
    [a1,f1]=max(Y(n*I(1)-fix(2/reso):n*I(1)+fix(2/reso)));
    base(n)=base(n)-2+f1*reso;a(n)=a1;
end
A=a';
base
A
