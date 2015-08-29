function v=anay_face(pic,L,c)
%filename  文件名
%f  特征向量的和
%L 每种颜色位数
%c3 各种被对比颜色

%这样比较大小时可以直接求绝对值然后用小于
pic=double(pic)-0.5;
[x,y,~]=size(pic);
v=zeros(2^(3*L),1);
step=2^(7-L);
%并行处理
l=2^(3*L);
pict1=pic(:,:,1);
pict2=pic(:,:,2);
pict3=pic(:,:,3);
c1=c(:,1);
c2=c(:,2);
c3=c(:,3);
parfor i=1:l;
    a= (abs(pict1-c1(i))<step)...
      &(abs(pict2-c2(i))<step)...
      &(abs(pict3-c3(i))<step);
     v(i)=sum(sum(a))/x/y;
end
return;
