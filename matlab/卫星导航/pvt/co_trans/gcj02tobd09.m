function [bd_lng,bd_lat]=gcj02tobd09(lng, lat)
%    """
%    火星坐标系(GCJ-02)转百度坐标系(BD-09)
%    谷歌、高德——>百度
%    :param lng:火星坐标经度
%    :param lat:火星坐标纬度
%    :return:
%    """
x_pi = 3.14159265358979324 * 3000.0 / 180.0;
z = sqrt(lng * lng + lat * lat) + 0.00002 * sin(lat * x_pi);
theta = atan2(lat, lng) + 0.000003 * cos(lng * x_pi);
bd_lng = z * cos(theta) + 0.0065;
bd_lat = z * sin(theta) + 0.006;
return;

