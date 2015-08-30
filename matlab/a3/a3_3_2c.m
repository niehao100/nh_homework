clear;close all;clc;
load('hall');
load('JpegCoeff');
pic=hall_gray;
%加密,这里只处理了8bit，所以只能加密英文字母,因为图像被分为315块,所以只能加密315bits
%因此改用短一些的句子
message='You jump I jump';
ms=reshape((dec2bin(message,8)-48)',1,8*length(message));
%以0000000为结束符
ms=2*[ms 0 0 0 0 0 0 0 0]-1;

%jpeg编码解码
%量化
[R,M,N]=quan(pic);
%haffman 编码
ERR_DC=[2*R(1,1) R(1,1:N*M-1)]-R(1,:);
%DC部分的编码
Category_DC=ceil(log2(abs(ERR_DC)+1));
DCstream=logical([]);
%AC部分
ACstream=logical([]);
Size_AC=ceil(log2(abs(R)+1));
zero16=[1 1 1 1 1 1 1 1 0 0 1];
for i=1:M*N
    DCstream=[DCstream DCTAB(Category_DC(i)+1,2:1+DCTAB(Category_DC(i)+1,1))];
    if ERR_DC(i)>=0;%减48是因为0的asscii码
        DCstream=[DCstream dec2bin(ERR_DC(i))-48];
    else%一补码
        DCstream=[DCstream ~(dec2bin(-ERR_DC(i))-48)];
    end

    AC_NONE_ZERO=[1;1+find(R(2:64,i))];
    %%%%%%%%%%%%%%%%%
    %%信息写入
    if(i<=length(ms))
        if(AC_NONE_ZERO(end)==64)
            R(64,i)=ms(i);
            Size_AC(64,i)=1;
        else
            R(AC_NONE_ZERO(end)+1,i)=ms(i);
            AC_NONE_ZERO=[AC_NONE_ZERO;AC_NONE_ZERO(end)+1];
            Size_AC(AC_NONE_ZERO(end),i)=1;
        end
    end
    %%%%%%%%%%%%%%%%%%
    if length(AC_NONE_ZERO)~=1
        for k=2:length(AC_NONE_ZERO)
            count0=AC_NONE_ZERO(k)-AC_NONE_ZERO(k-1)-1;
            while count0>15
                ACstream=[ACstream zero16];
                count0=count0-16;
            end
            ACstream=[ACstream  ACTAB( (count0*10+Size_AC(AC_NONE_ZERO(k),i)),...
            4:(3+ACTAB(count0*10+Size_AC(AC_NONE_ZERO(k),i),3)) )];
            if R(AC_NONE_ZERO(k),i)>=0;%减48是因为0的asscii码
                ACstream=[ACstream dec2bin(abs( R(AC_NONE_ZERO(k),i) ))-48];
            else%一补码
                ACstream=[ACstream ~(dec2bin(abs( R(AC_NONE_ZERO(k),i) ))-48)];
            end
        end
    end
    ACstream=[ACstream 1 0 1 0]; 
end

[ACstream,DCstream,m,n]=haff(R,M,N);
%解密
%判断DC
i=1;
DC=[];
%解码至残差
while(i<=length(DCstream))
    for ca=1:12
        try
            if(DCstream(i:i+DCTAB(ca,1)-1)==DCTAB(ca,2:1+DCTAB(ca,1)));
                i=i+DCTAB(ca,1);
                if(ca==1)
                    DC=[DC 0];
                    i=i+1;
                    break
                elseif(DCstream(i)==1)
                    %此处为ca(Category的序号)与数字位数的对应关系
                    DC=[DC bin2dec(num2str(DCstream(i:i+ca-2)))];
                else
                    DC=[DC -bin2dec(num2str(~DCstream(i:i+ca-2)))];
                end
                i=i+ca-1;
                break;
            end
        end
    end
end
%反差分
for i=2:length(DC)
    DC(i)=DC(i-1)-DC(i);
end
%判断AC,并得到数据串
i=1;count=1;
AC=zeros(63,length(DC));tmp=[];
proc=[];
%解码至zig-zag前
while(i<=length(ACstream))
        %判断EOB
        if(ACstream(i:i+3)==[1 0 1 0])
            i=i+4;
            AC(:,count)=[tmp;zeros(63-length(tmp),1)];
            noz=find(tmp);
            if(noz)
                proc=[proc tmp(noz(end))];
            end
            tmp=[];
            count=count+1;
            continue;
        end
        %判断ZRL
        if(i+10<=length(ACstream))
            if(ACstream(i:i+10)==[1 1 1 1 1 1 1 1 0 0 1])
                i=i+11;
                tmp=[tmp;zeros(16,1)];
                continue;
            end
        end
        for j=1:160
            %避免溢出
            try
                if(ACstream(i:i+ACTAB(j,3)-1)==ACTAB(j,4:3+ACTAB(j,3)));
                    i=i+ACTAB(j,3);
                    Run=fix((j-1)/10);
                    if(ACstream(i)==1)
                        %此处为run/size与数字位数的对应关系
                        tmp=[tmp;zeros(Run,1);bin2dec(num2str(ACstream(i:i+j-10*Run-1)))];
                else
                    tmp=[tmp;zeros(Run,1);-bin2dec(num2str(~ACstream(i:i+j-10*Run-1)))];
                end
                i=i+j-10*Run;
                break;
            end
        end
    end
end

%反zigzag
source=[DC;AC];
%偶数自然是0，奇数对应的值为1
%二进制转换为字符，因为reshape的特性，需要进行转置
%解密
%偶数自然是0，奇数对应的值为1
for i=1:fix(M*N/8)-1
    if(proc(8*i-7:8*i)==([0 0 0 0 0 0 0 0]-1))
        break;
    end
end
dms=uint8((proc(1:8*i-8)+1)/2);
%二进制转换为字符，因为reshape的特性，需要进行转置
message=char(bin2dec(num2str(reshape(dms,8,i-1)')))'

pic=dequan(source,m,n,pic);
