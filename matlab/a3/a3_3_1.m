clear;close all;clc;
load('hall');
%加密,这里只处理了8bit，所以只能加密英文字母
message='A quick brown fox jump over the lazy dog';
ms=reshape((dec2bin(message,8)-48)',1,8*length(message));
%以0000000为结束符，直接从第一个像素开始加
ms=uint8([ms 0 0 0 0 0 0 0 0]);
[m,n]=size(hall_gray);
pic=reshape(hall_gray,1,m*n);
%除以2，fix再乘2等于把最低bit清零，然后加上需要加密的信息
pic(1:length(ms))=fix(pic(1:length(ms))/2)*2+ms;
pic=reshape(pic,m,n);
imshow(pic);

%解密
to_proc=mod(reshape(pic,1,m*n),2);
%偶数自然是0，奇数对应的值为1
for i=1:fix(m*n/8-1)
    if(to_proc(8*i-7:8*i)==[0 0 0 0 0 0 0 0])
        break;
    end
end
dms=to_proc(1:8*i-8);
%二进制转换为字符，因为reshape的特性，需要进行转置
message=char(bin2dec(num2str(reshape(dms,8,i-1)')))'

%jpeg编码解码
[R,M,N]=quan(pic);
[ACstream,DCstream,m,n]=haff(R,M,N);
[source]=dehaff(ACstream,DCstream,m,n);
pic=dequan(source,m,n,pic);
%解密
to_proc=mod(reshape(pic,1,m*n),2);
%偶数自然是0，奇数对应的值为1
for i=1:fix(m*n/8-1)
    if(to_proc(8*i-7:8*i)==[0 0 0 0 0 0 0 0])
        break;
    end
end
dms=to_proc(1:8*i-8);
%二进制转换为字符，因为reshape的特性，需要进行转置
message=char(bin2dec(num2str(reshape(dms,8,i-1)')))'
