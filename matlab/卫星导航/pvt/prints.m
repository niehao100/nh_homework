[~,n]=size(position_bd09);
s=[];
for i=1:n
    s=[s 'data.data[' num2str(i-1) '][0]=' num2str(position_bd09(1,i),15) ';'];
    s=[s 'data.data[' num2str(i-1) '][1]=' num2str(position_bd09(2,i),15) ';'];
end
s