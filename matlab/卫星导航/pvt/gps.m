clear;
close;
load L1.mat
[lng,lat]=gcj02towgs84(116.3324885066,40.0014938354);
pre=lla2ecef([lat,lng,0]);
%以清华大学主楼为起始点，坐标来自高德地图

position_ecef=zeros(3,200);
position_wgs84=zeros(2,200);
position_gcj02=zeros(2,200);
position_bd09=zeros(2,200);
for i=1:200
    rho=PseudoRange(:,i);
    sat=SatInfo(:,i);
    position_ecef(:,i)=pvt(rho,sat,pre);
    lla=ecef2lla(position_ecef(:,i)');%转换为wgs84
	lat=lla(1);
	lng=lla(2);
    position_wgs84(:,i)=[lng;lat];
    [lng,lat]=wgs84togcj02(lng,lat);
    position_gcj02(:,i)=[lng;lat];
    [lng,lat]=gcj02tobd09(lng,lat);
    position_bd09(:,i)=[lng;lat];  
end
v=sum((position_ecef(:,2:200)-position_ecef(:,1:199)).^2).^0.5;