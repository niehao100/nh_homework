qclear;clc;format long;
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

Y1=zeros(2,nf);
Y1(1,2:nf)=Y(1:nf-1);
Y1(2,1:nf-1)=Y(2:nf);
Y1=(Y1-[Y;Y]);
Y1=[1 1]*(Y1<0);
Y1=(Y1==2);
f=f.*Y1;
%取极大点对应的频率
if (max(Y.*Y1))>0.03
    f=f.*((Y.*Y1)>0.03);
else 
    f=f.*((Y.*Y1)>0.013);
end
%加幅值的限制
[list,I]=sort(f+10000.*(f==0));
%得到基频
base=(1:6)*list(1);
a=zeros(1,6);
a(1)=Y(I(1));
for n=2:6
    [a1,f1]=max(Y(n*I(1)-fix(2/reso):n*I(1)+fix(2/reso)));
    base(n)=base(n)-2+f1*reso;a(n)=a1;
end
A=a';


base=220;f=8000;s=zeros(f*0.05,1);
s=[s;m_note_guitar(10,0.5,base,f,A)];
s=[s;m_note_guitar(10,0.25,base,f,A)];
s=[s;m_note_guitar(12,0.25,base,f,A)];
s=[s;m_note_guitar(5,1,base,f,A)];
s=[s;m_note_guitar(3,0.5,base,f,A)];
s=[s;m_note_guitar(3,0.25,base,f,A)];
s=[s;m_note_guitar(0,0.25,base,f,A)];
s=[s;m_note_guitar(5,1,base,f,A)];
sound(s,f);


