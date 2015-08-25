function [C]=my_dct2(P)
[m n]=size(P);
D1=sqrt(2/m)*[sqrt(0.5)*ones(1,m);cos(kron((1:2:(2*m-1)),(1:m-1)')*pi/2/m)];
D2=sqrt(2/n)*[sqrt(0.5)*ones(1,n);cos(kron((1:2:(2*n-1)),(1:n-1)')*pi/2/n)];
C=D1*double(P)*D2';
return;
