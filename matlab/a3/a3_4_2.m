clear;close all;clc;
load face_4;
L=bit;
mypool=parpool();
exam=double(imread('Faces/example.bmp'));
[m,n,~]=size(exam);
exam(:,:,3)=0;
%存储合适的元素
c1=2^(7-L)-1:2^(8-L):2^8-1;
c3=[reshape(repmat(c1,2^(2*L),1),2^(3*L),1) reshape(repmat(c1,2^L,2^L),2^(3*L),1) repmat(c1',2^(2*L),1)];
[~,list]=sort(v,'descend');

index_find=zeros(m,n,10);
step=8;
for i=1:6
    index_find(:,:,i)=(abs(exam(:,:,1)-c3(list(i),1))<step)...
                &(abs(exam(:,:,2)-c3(list(i),2))<step)...
                &(abs(exam(:,:,3)-c3(list(i),3))<step);
end
index=sum(index_find,3);
index=bwareaopen(index,2);
 for k=[100 60 30]
     [y,x]=find(index);
     u0=zeros(2^(3*L),1);
     u=zeros(2^(3*L),length(x));
     mk=fix(m/k);nk=fix(n/k);
     for i=1:length(x)
         try 
             pic=exam(y(i)-mk:y(i)+mk,x(i)-nk:x(i)+nk,:);
             u(:,i)=anay_face(pic,L,c3);
             d=1-sum(sqrt(v.*u(:,i)));
             if(d>0.45&&k>60)
                 index(y(i),x(i))=0;
             end
         catch
             index(y(i),x(i))=0;
         end
     end
 clear u x y;
 end
[y,x]=find(index);


 for i=1:length(x)
     index(y(i)-mk:y(i)+mk,x(i)-nk:x(i)+nk)=1;
 end
%差分得到边框
e_index=2*index-[zeros(m,1) index(:,1:end-1)]-[zeros(1,n);index(1:end-1,:)];
exam(:,:,1)=exam(:,:,1)+255*(e_index~=0);
imshow(uint8(exam));

delete(mypool);

