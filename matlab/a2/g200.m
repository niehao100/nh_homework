n=0:8000;
f1=200;
f2=300;
x1=double(mod(n,round(8000/f1))==0);
x2=double(mod(n,round(8000/f2))==0);

sound(x1,8000);
pause(1);
sound(x2,8000);