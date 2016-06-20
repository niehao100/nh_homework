function [ret]=transformlat(lng,lat)
ret=-100.0+2.0*lng+3.0*lat+0.2*lat*lat+0.1*lng*lat+0.2*sqrt(abs(lng));
ret=ret+(20.0*sin(6.0*lng*pi)+20.0*sin(2.0*lng*pi))*2.0/3.0;
ret=ret+(20.0*sin(lat*pi)+40.0*sin(lat/3.0*pi))*2.0/3.0;
ret=ret+(160.0*sin(lat/12.0*pi)+320*sin(lat*pi/30.0))*2.0/3.0;
return;
