clear;clc;
load('a.mat')
x_exact = ceil(rand(100,1)*100);
x=conjugate_gradient(A(:,:,1,1),x_exact);