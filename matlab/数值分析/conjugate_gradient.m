function [x_k] = conjugate_gradient(A,x)
%CONJUGATE_GRADIENT Summary of this function goes here
%   Detailed explanation goes here
b = A*x;
x_k=0;
%r0
r = b;
p = b;
%k=1
f=[];
for k=0:100
    if(r'*r<1e-6)
        k
        norm(r)
        plot(f);
        return;
    end
    a=(r'*r)/(p'*(A*p));
    x_k = x_k+a*p;
    r_tmp = r - a*A*p;
    belta = r_tmp'*r_tmp/(r'*r);
    f = [f norm(r_tmp)/norm(r)];
    r=r_tmp;
    p = r + belta*p;
end
figure;
norm(r)
plot(f);
return;
end

