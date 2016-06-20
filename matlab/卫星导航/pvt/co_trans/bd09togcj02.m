function [gc_lng gc_lat]=bd09togcj02(bd_lon, bd_lat)
%    百度坐标系(BD-09)转火星坐标系(GCJ-02)
%    百度——>谷歌、高德
%    :param bd_lat:百度坐标纬度
%    :param bd_lon:百度坐标经度
%    :return:转换后的坐标列表形式
%    """
x_pi = 3.14159265358979324 * 3000.0 / 180.0;
x = bd_lon - 0.0066;
y = bd_lat - 0.006;
z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
gc_lng = z * cos(theta);
gc_lat = z * sin(theta);
return ;
