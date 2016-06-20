function [lng,lat]=gcj02towgs84(lng, lat)
  %  """
  %  GCJ02(火星坐标�?转GPS84
  %  :param lng:火星坐标系的经度
  %  :param lat:火星坐标系纬�?  %  :return:
  %  """
  x_pi = 3.14159265358979324 * 3000.0 / 180.0;
  a = 6378245.0 ; 
  ee = 0.00669342162296594323;
  dlat = transformlat(lng - 105.0, lat - 35.0);
  dlng = transformlng(lng - 105.0, lat - 35.0);
  radlat = lat / 180.0 * pi;
  magic = sin(radlat);
  magic = 1 - ee * magic * magic;
  sqrtmagic = sqrt(magic);
  dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi);
  dlng = (dlng * 180.0) / (a / sqrtmagic * cos(radlat) * pi);
  mglat = lat + dlat;
  mglng = lng + dlng;
  lng=lng * 2 - mglng;
  lat=lat * 2 - mglat;
  return;

