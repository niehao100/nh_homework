clear;close all; clc;
load  'mtx.mat';
figure
for i=1:r_count
    for j=1:c_count
        subplot(r_count,c_count,j+i*c_count-c_count);
        imshow(uint8(pic(:,:,j+(i-1)*c_count)));
        hold on;
    end
end
hold on;
s=zeros(size(pic(:,:,1))/2);
steps(1) = 0;
mtx_tmp=zeros(size(mtx));
siz=max(max(mtx));
pause(4);

while(siz~=0)
    for i=siz:-1:1
        [m,n]=find(mtx==i);
        for j=1:length(m)
            for k=j+1:length(n)
                if mtx(m(j),n(j))~=0&&mtx(m(k),n(k))~=0;
                    if detect(mtx,m(j),n(j),m(k),n(k))==1
                        steps=[steps m(j) n(j) m(k) n(k)];
                        subplot(r_count,c_count,m(j)*c_count-c_count+n(j));
                        imshow(uint8(s));
                        subplot(r_count,c_count,m(k)*c_count-c_count+n(k));
                        imshow(uint8(s));
                        pause(1.5);
                        mtx(m(j),n(j))=0;
                        mtx(m(k),n(k))=0;
                    end
                end
            end
        end
    end
    siz=max(max(mtx));
    if(mtx_tmp==mtx)
        break;
    end
    mtx_tmp=mtx;%避免死循环
end


