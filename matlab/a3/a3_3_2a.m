clear;close all;clc;
load('hall');
pic=hall_gray;
%加密,这里只处理了8bit，所以只能加密英文字母
message='A quick brown fox jump over the lazy dog';
ms=reshape((dec2bin(message,8)-48)',1,8*length(message));
%以0000000为结束符，直接从第一个像素开始加
ms=[ms 0 0 0 0 0 0 0 0];
%解密

%jpeg编码解码
%量化
[R,M,N]=quan(pic);
%这里加密用的R是zig-zag后的值显然R是64*len的矩阵
[~,len]=size(R);
%除以2，fix再乘2等于把最低bit清零，然后加上需要加密的信息
to_proc=reshape(R,1,64*len);
to_proc(1:length(ms))=fix(to_proc(1:length(ms))/2)*2+ms;
R1=reshape(to_proc,64,len);

%haffman 编码
[ACstream,DCstream,m,n]=haff(R1,M,N);
[source]=dehaff(ACstream,DCstream,m,n);
%解密
proc=mod(reshape(source,1,64*len),2);
%偶数自然是0，奇数对应的值为1
for i=1:fix(8*len-1)
    if(proc(8*i-7:8*i)==[0 0 0 0 0 0 0 0])
        break;
    end
end
dms=proc(1:8*i-8);
%二进制转换为字符，因为reshape的特性，需要进行转置
message=char(bin2dec(num2str(reshape(dms,8,i-1)')))'

pic=dequan(source,m,n,pic);
