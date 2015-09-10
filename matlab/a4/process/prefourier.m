function [t,omg,FT,IFT] = prefourier(Trg,N,OMGrg,K)
% 输入参数： 
% Trg  : 二维矢量，两个元素分别表示时域信号的起止时间；
% N    : 时域抽样数量；
% OMGrg: 二维矢量，两个元素分别表示频谱的起止频率；
% K    : 频域抽样数量。
% 输出参数：
% t    : 抽样时间；
% omg  : 抽样频率；
% FT   : 实现傅里叶变换的矩阵~U~及系数；
% IFT  : 实现傅里叶逆变换的矩阵~V~及系数。
T = Trg(2)-Trg(1);
t = linspace(Trg(1),Trg(2)-T/N,N)';
OMG = OMGrg(2)-OMGrg(1);
omg = linspace(OMGrg(1),OMGrg(2)-OMG/K,K)';
FT = T/N*exp(-j*kron(omg,t.'));
IFT = OMG/2/pi/K*exp(j*kron(t,omg.'));
