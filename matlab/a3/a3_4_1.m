%mypool=parpool();
%修改L可以改变采样率
L=5
%c1=2^(7-L)-1:2^(8-L):2^8-1;
v=zeros(2^(3*L),1);
%c3=[reshape(repmat(c1,2^(2*L),1),2^(3*L),1) reshape(repmat(c1,2^L,2^L),2^(3*L),1) repmat(c1',2^(2*L),1)];
for j=1:31
    filename=['Faces/' num2str(j) '.bmp'];
    pic=imread(filename);
    v=v+anay_face(pic,L);
end
%delete(mypool);
v=v/31;
save face_5.mat v L
