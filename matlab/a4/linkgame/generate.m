clear;clc;close all;
check=0;
r=[];
while(check==0)
    r=ceil(21*rand(1,42));
    r=[r r];
    r=reshape(r,[7,12]);
    check=omg_check(r);
end
r
