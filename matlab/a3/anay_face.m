function v=anay_face(pic,L)
%filename  文件名
%f  特征向量的和
%L 每种颜色位数
pic=double(pic);
[x,y,~]=size(pic);
v=zeros(2^(3*L),1);
%除以步长,+2^(7-L)是为了解决最小和最大值的问题，
%避免超出范围
pic=round((pic+2^(7-L))/2^(8-L))-1;
to_proc=reshape(pic,1,x*y,3);
n=2^(2*L)*to_proc(1,:,1)+2^L*to_proc(1,:,2)+to_proc(1,:,3)+1;
A=unique(n);
n1=histc(n,A);
%找到重复的元素和重复次数
v(A)=n1/x/y;

%anay_face非常适合并行处理
%并行处理
%这样比较大小时可以直接求绝对值然后用小于
%pic=pic-0.5;
%step=2^(7-L);
%l=2^(3*L);
%pict1=pic(:,:,1);
%pict2=pic(:,:,2);
%pict3=pic(:,:,3);
%c1=c(:,1);
%c2=c(:,2);
%c3=c(:,3);
%parfor i=1:l;
%    a= (abs(pict1-c1(i))<step)...
%      &(abs(pict2-c2(i))<step)...
%      &(abs(pict3-c3(i))<step);
%     v(i)=sum(sum(a))/x/y;
%end
return;
