clear;close all;clc;
load('hall.mat');
[m,n,q]=size(hall_color);
r=0.5*min(m,n);
o=0.5*[m n];
circle=hall_color;
board=hall_gray;
step_m=round(m/8);
step_n=round(n/8);
for i=1:m
    for j=1:n
        if(sum(([i j]-o).^2)<=sum(r.^2))
            circle(i,j,1)=255;
            circle(i,j,2)=0;
            circle(i,j,3)=0;
        end
        if(mod(fix((i-1)/step_m),2)==mod(fix((j-1)/step_n),2))
            board(i,j)=0;
        end
    end
end
imshow(circle);
figure
imshow(board);
imwrite(circle,'circle.bmp');
imwrite(board,'board.bmp');
