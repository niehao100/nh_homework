function [ACstream,DCstream,m,n]=haff(R,M,N);
%DC部分
%差分编码
m=8*M;n=8*N;
load('JpegCoeff');
ERR_DC=[2*R(1,1) R(1,1:N*M-1)]-R(1,:);
%DC部分的编码
DCstream=logical([]);
ACstream=logical([]);
Category_DC=ceil(log2(abs(ERR_DC)+1));
Size_AC=ceil(log2(abs(R)+1));
%AC部分
zero16=[1 1 1 1 1 1 1 1 0 0 1];
for i=1:M*N
    DCstream=[DCstream DCTAB(Category_DC(i)+1,2:1+DCTAB(Category_DC(i)+1,1))];
    if ERR_DC(i)>=0;%减48是因为0的asscii码
        DCstream=[DCstream dec2bin(ERR_DC(i))-48];
    else%一补码
        DCstream=[DCstream ~(dec2bin(-ERR_DC(i))-48)];
    end

    AC_NONE_ZERO=[1;1+find(R(2:64,i))];
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
return;
