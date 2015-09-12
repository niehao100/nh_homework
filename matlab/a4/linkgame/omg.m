function steps = omg(mtx)
    % -------------- 输入参数说明 --------------
    
    %   输入参数中，mtx为图像块的矩阵，类似这样的格式：
    %   [ 1 2 3;
    %     0 2 1;
    %     3 0 0 ]
    %   相同的数字代表相同的图案，0代表此处没有块。
    %   可以用[m, n] = size(mtx)获取行数和列数。
    
    %   注意mtx矩阵与游戏区域的图像不是位置对应关系。下标(x1, y1)在连连看界面中
    %   代表的是以左下角为原点建立坐标系，x轴方向第x1个，y轴方向第y1个
    
    % --------------- 输出参数说明 --------------- %
    
    %   要求最后得出的操作步骤放在steps数组里,格式如下：
    %   steps(1)表示步骤数。
    %   之后每四个数x1 y1 x2 y2，代表把mtx(x1,y1)与mtx(x2,y2)表示的块相连。
    %   示例： steps = [2, 1, 1, 1, 2, 2, 1, 3, 1];
    %   表示一共有两步，第一步把mtx(1,1)和mtx(1,2)表示的块相连，
    %   第二步把mtx(2,1)和mtx(3,1)表示的块相连。
    
    %% --------------  请在下面加入你的代码 O(∩_∩)O~  ------------
    
    steps(1) = 0;
    mtx_tmp=mtx;
    size=max(max(mtx));
    count=0;
    while(size~=0)
        for i=1:size
            [m,n]=find(mtx==i);
            for j=1:length(m)
                for k=j+1:length(n)   
                    if mtx(m(j),n(j))~=0&&mtx(m(k),n(k))~=0;
                        if detect(mtx,m(j),n(j),m(k),n(k))==1
                            count=count+1;
                            steps=[steps m(j) n(j) m(k) n(k)];
                            mtx(m(j),n(j))=0;
                            mtx(m(k),n(k))=0;
                        end
                    end
                end
            end
        end
        size=max(max(mtx));
        if(mtx_tmp==mtx) break;
        end
        mtx_tmp=mtx;%避免死循环
    end
    steps(1)=count;
    return
end
