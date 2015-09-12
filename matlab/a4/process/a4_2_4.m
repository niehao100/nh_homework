load corr_capture.mat;
diff=[161 166 169 170 171 175 176 177 179 182];
    for j=1:10
        i=2*diff(j);
        a=fix((index(i)-1)/siz)+1;
        b=mod(index(i)-1,siz)+1;
        subplot(2,10,(j));
        imshow(uint8(pic(:,:,a)));
        title(value(i));
        subplot(2,10,(j+10));
        imshow(uint8(pic(:,:,b)));
    end
