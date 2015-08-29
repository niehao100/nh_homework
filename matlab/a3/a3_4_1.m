%2^24实在太大,这里选用2^9
%anay_face非常适合并行处理
mypool=parpool();
L=3
c1=2^(7-L)-1:2^(8-L):2^8-1;
v=zeros(2^(3*L),1);
c3=[reshape(repmat(c1,2^(2*L),1),2^(3*L),1) reshape(repmat(c1,2^L,2^L),2^(3*L),1) repmat(c1',2^(2*L),1)];
for j=1:31
    filename=['Faces/' num2str(j) '.bmp'];
    pic=imread(filename);
    v=v+anay_face(pic,L,c3);
end
delete(mypool);
v=v/31;
bit=L;
save face.mat v bit
