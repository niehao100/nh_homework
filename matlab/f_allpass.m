function [b,a]=f_allpass(p)

r=abs(p);
phi=angle(p);
z=r.^(-1).*exp(1i*phi);
[b,a]=zp2tf(z,p,1);
return