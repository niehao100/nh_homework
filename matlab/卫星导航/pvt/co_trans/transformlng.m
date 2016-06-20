function[ret]=transformlng(lng,lat)
ret=300.0+lng+2.0*lat+0.1*lng*lng+0.1*lng*lat+0.1*sqrt(abs(lng));
ret=ret+(20.0*sin(6.0*lng*pi)+20.0*sin(2.0*lng*pi))*2.0/3.0;
ret=ret+(20.0*sin(lng*pi)+40.0*sin(lng/3.0*pi))*2.0/3.0;
ret=ret+(150.0*sin(lng/12.0*pi)+300.0*sin(lng/30.0*pi))*2.0/3.0;
return;
