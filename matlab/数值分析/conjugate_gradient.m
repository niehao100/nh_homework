function [x_k] = conjugate_gradient(A,x)
%CONJUGATE_GRADIENT Summary of this function goes here
%   Detailed explanation goes here
b = A*x;
x_k=0;
%r0
r = b;
p=r;
%k=1
for k=0:100
    if(r'*r<1e-6)
        k
        return;
    end
    a=(r'*r)/(p'*(A*p));
    x_k = x_k+a*p;
    r_tmp = r - a*A*x_k;
    belta = r'*r/(r_tmp'*r_tmp);
    r=r_tmp;
    p = r + belta*p;
end
k
return;
end

