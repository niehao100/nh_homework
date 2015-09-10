for j=20:-1:15
    figure
for i=1:10
a=fix(index(i+10*j)/size)+1;
b=mod(index(i+10*j)-1,size)+1;
subplot(2,10,i);
imshow(uint8(pic(:,:,a)));
title(i+10*j);
subplot(2,10,i+10);
imshow(uint8(pic(:,:,b)));
title(value(i+10*j));
end
end