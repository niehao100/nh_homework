function [pre]=pvt(rho,sat,pre)
%%%%输出 pre为最终得到的坐标
%%%%输入 rho为伪距
%%%%     sat为卫星坐标
%%%%     pre为预测的用户位置

%获得卫星的数量
[n,~]=size(rho);

%将卫星位置从结构体转换为n*3的矩阵
sat=reshape(struct2array(sat),3,n)';

error=100;
%循环条件，当计算修正位置小于20m时停止迭代
count=1; 
%循环条件，防止结果不收敛而导致死循环
while(error>20||count>20)
    count=count+1;
    tmp_pre=repmat(pre,n,1);
	%矩阵化，方便计算
    r=(sum((sat-tmp_pre).^2,2)).^0.5;
    delta_rho=rho-r;
    H=-(sat-tmp_pre).*repmat(r.^-1,1,3);
    delta_p=inv(H'*H)*H'*delta_rho;

    error=sum(delta_p.^2)^0.5;
	%error为delta_p的长度
    pre=pre+delta_p';
end
return;
