function [bool]=check(x,y,mtx,m,n)
    if mtx(x(1),y(2))==0
        if (sum(mtx(x(1),min(y):max(y)))+sum(mtx(min(x):max(x),y(2))))==(mtx(x(1),y(1))+mtx(x(2),y(2)))
            bool=1;
            return
        end
    end
    if mtx(x(2),y(1))==0
        if (sum(mtx(x(2),min(y):max(y)))+sum(mtx(min(x):max(x),y(1))))==(mtx(x(1),y(1))+mtx(x(2),y(2)))
            bool=1;
            return
        end
    end
    %ฑ฿ิต
    if (x(1)==1&&x(2)==1)||(x(1)==m&&x(2)==m)||(y(1)==1&&y(2)==1)||(y(1)==n&&y(2)==n)
            bool=1;
            return;
    end
    bool=0;
    return;
end
