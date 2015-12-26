function bool = detect(mtx, x1, y1, x2, y2)
    % ========================== 参数说明 ==========================

    % 输入参数中，mtx为图像块的矩阵，类似这样的格式：
    % [ 1 2 3;
    %   0 2 1;
    %   3 0 0 ]
    % 相同的数字代表相同的图案，0代表此处没有块。
    % 可以用[m, n] = size(mtx)获取行数和列数。
    % (x1, y1)与（x2, y2）为需判断的两块的下标，即判断mtx(x1, y1)与mtx(x2, y2)
    % 是否可以消去。

    % 注意mtx矩阵与游戏区域的图像不是位置对应关系。下标(x1, y1)在连连看界面中
    % 代表的是以左下角为原点建立坐标系，x轴方向第x1个，y轴方向第y1个

    % 输出参数bool = 1表示可以消去，bool = 0表示不能消去。

    %% 在下面添加你的代码O(∩_∩)O
        [m, n] = size(mtx);
        x=[x1 x2];
        y=[y1 y2];
        [x_max,which_x_max]=max(x);
        [x_min,which_x_min]=min(x);
        [y_max,which_y_max]=max(y);
        [y_min,which_y_min]=min(y);
        if(mtx(x1,y1)~=mtx(x2,y2))
            bool=0;
            return;
        end

        bool = 0;
        %直线情况
        if x1==x2
            if sum(mtx(x1,y_min:y_max))==(mtx(x1,y1)+mtx(x2,y2))
                bool=1;
                return
            end
        end
        if y1==y2
            if sum(mtx(x_min:x_max,y1))==(mtx(x1,y1)+mtx(x2,y2))
                bool=1;
                return
            end     
        end
        %单折线情况和边缘
        if (sum(mtx(1:x(1),y(1)))==mtx(x(1),y(1))&&sum(mtx(1:x(2),y(2)))==mtx(x(2),y(2)))
            bool=1;
            return;
        end
        if (sum(mtx(x(1):m,y(1)))==mtx(x(1),y(1))&&sum(mtx(x(2):m,y(2)))==mtx(x(2),y(2)))
            bool=1;
            return;
        end
        if (sum(mtx(x(1),1:y(1)))==mtx(x(1),y(1))&&sum(mtx(x(2),1:y(2)))==mtx(x(2),y(2)))
            bool=1;
            return;
        end
        if (sum(mtx(x(1),y(1):n))==mtx(x(1),y(1))&&sum(mtx(x(2),y(2):n))==mtx(x(2),y(2)))
            bool=1;
            return;
        end
        if check(x,y,mtx,m,n)==1
            bool=1;
            return;
        end
        %双折线x方向
        s=0;
        x_tmp=x;
        for i=x_min-1:-1:1
            s=s+mtx(i,y(which_x_min));
            if s~=0;
                break;
            end
            x_tmp(which_x_min)=i;
            if check(x_tmp,y,mtx,m,n)==1
                bool=1;
                return;
            end
        end
        s=0;
        for i=x_min+1:m
            s=s+mtx(i,y(which_x_min));
            if s~=0;
                break;
            end
            x_tmp(which_x_min)=i;
            if check(x_tmp,y,mtx,m,n)==1
                bool=1;
                return;
            end
        end
        s=0;
        y_tmp=y;
        for i=y_min-1:-1:1
            s=s+mtx(x(which_y_min),i);
            if s~=0;
                break;
            end
            y_tmp(which_y_min)=i;
            if check(x,y_tmp,mtx,m,n)==1
                bool=1;
                return;
            end
        end
        s=0;
        for i=y_min+1:n
            s=s+mtx(x(which_y_min),i);
            if s~=0;
                break;
            end
            y_tmp(which_y_min)=i;
            if check(x,y_tmp,mtx,m,n)==1
                bool=1;
                return;
            end
        end
    end

