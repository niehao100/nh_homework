clear;clc;close all;
load 'corr_capture.mat';

[m,n]=size(corr);
mtx=zeros(r_count,c_count);
tmp=mtx';
 [~,same]=max(corr);
 where=zeros(12*7,1);
A=repmat({[]},12*7,1);
for i=1:n
    j=min(i,same(i));
    k=max(i,same(i));
    if where(j)~=0 && where(k)~=0 
        A{min(where(j),where(k))}=[A{min(where(j),where(k))} A{max(where(j),where(k))}];
        if where(j)~=where(i)
            A{max(where(j),where(k))}=[];
        end
        where(k)=where(j);
    else if where(j)~=0
            A{where(j)}=[A{where(j)} i same(i)];
            where(i)=where(j);
            where(same(i))=where(j);
        else if where(k)~=0
                A{where(k)}=[A{where(k)} i same(i)];
                where(i)=where(k);
                where(same(i))=where(k);
            else
                A{j}=[A{j} i same(i)];
                where(i)=j;
                where(same(i))=j;
            end
        end
    end
      
 end
%     r_a=fix((i-1)/c_count)+1;
%     c_a=mod(i-1,c_count)+1;
%     r_b=fix((index-1)/c_count)+1;
%     c_b=mod(index-1,c_count)+1;
[m,n]=find(corr>0.773);
for i=1:length(m)
    mi=min(m(i),n(i));
    ma=max(m(i),n(i));
    if where(m(i))~=where(n(i))
        A{min(where(mi),where(ma))}=[A{where(mi)} A{where(ma)}];
        A{max(where(mi),where(ma))}=[];
        where(ma)=where(mi);
    end
        
end
type=1;
for i=1:84
    B=unique(A{i});
    if B
        r_a=fix((B-1)/c_count)+1;
        c_a=mod(B-1,c_count)+1;
        tmp=mtx';
        tmp(B)=type;
        mtx=tmp';
        type=type+1;
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
save mtx.mat mtx pic img r_count c_count