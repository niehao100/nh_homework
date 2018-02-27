function [ x ] = Lanczos( A,x_exact )
%LANCZOS Summary of this function goes here
%   Detailed explanation goes here
b=A*x;
[n,m]=size(A);
Q=zero(n,m);
Q(1,1)=1;
T=zero(n,m);
alpha=Q(:,1)'*A*Q(:,1);
r=A*Q(:,1)-alpha*Q(:,1);
belta=norm(r);
for i=2:n-1
    for j=i-1:i+1
        
    end
end

end

