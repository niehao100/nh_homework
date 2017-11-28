clear;
clc;
seed=ceil(sort(rand(5,100)*100,2,'descend'))+1;
for i=1:5
    D(:,:,i)=diag(seed(1,:));
end
for i=1:10
    r_m=ceil(rand(100,100)*100);
    [Q(:,:,i),~]=qr(r_m);
end
for i=1:5
    for j=1:10
        A(:,:,i,j)=Q(:,:,j)*D(:,:,i)*Q(:,:,j)';
    end
end
save 'A.mat' A D Q 
