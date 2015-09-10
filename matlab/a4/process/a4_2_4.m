clear;close all;clc;
load 'corr_capture.mat';
[m,n]=find(corr>0.72);
mtx=zeros(r_count,c_count);
v=zeros(r_count,c_count);
same=zeros()
type=1;
for i=1:length(m)
    r_a=fix((n(i)-1)/c_count)+1;
    c_a=mod(n(i)-1,c_count)+1;
    r_b=fix((m(i)-1)/c_count)+1;
    c_b=mod(m(i)-1,c_count)+1;
    if mtx(r_a,c_a)==0
        mtx(r_a,c_a)=type;
        type=type+1;
    end
    if mtx(r_b,c_b)==0
        mtx(r_b,c_b)=mtx(r_a,c_a);
        v(r_b,c_b)=corr(n(i),m(i));
    end
    if(v(r_b,c_b)<corr(m(i),n(i)))
        mtx(r_b,c_b)=mtx(r_a,c_a);
        v(r_b,c_b)=corr(m(i),n(i));
    end
end

count=max(max(mtx));
for i=1:count
    t=reshape(mtx',1,[]);
    in=find(t==i);
    subplot(3,8,i);
    imshow(uint8(pic(:,:,in(1))));
    title(i);
end