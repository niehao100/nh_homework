function p=sat(h,m)

mu=3.986005e14;
Omega_e=7.2921151467e-5;
t=(h*60+m)*60+172800-3.470480442047e-05;
%GPS ICD-GPS-200D的算法?
data=[ 9.800000000000e+01	-1.215625000000e+01 4.510545025162e-09 8.560021623488e-01;
   -5.103647708893e-07 1.535527291708e-03 1.173838973045e-05 5.153689140320e+03;
    1.800000000000e+05 4.097819328308e-08	-1.246393642921e+00	-1.303851604462e-08;
    9.592314829730e-01 1.494375000000e+02	-2.715739289762e+00	-8.019262605905e-09;
   -3.117987019532e-10 0.000000000000e+00 1.899000000000e+03 0.000000000000e+00;
    2.000000000000e+00 0.000000000000e+00 2.328306436539e-09 9.800000000000e+01;
   ];
A=(data(2,4))^2;
t_oe=data(3,1);
delta_n=data(1,3);

M_0=data(1,4);
e=data(2,2);
omega=data(4,3);
C_rs=data(1,2);
C_uc=data(2,1);
C_us= data(2,3);
C_ic= data(3,2);
C_is= data(3,4);
C_rc= data(4,2);
i_0=data(4,1);
idot=data(5,1);
Omega_0=data(3,3);
Omega_dot=data(4,4);

t_k=t-t_oe;
n_0=sqrt(mu/A^3);


while t_k>302400
    t_k=t_k-604800;
end
while t_k<-302400
    t_k=t_k*+604800;
end   
n=n_0+delta_n;
M_k=M_0+n*t_k;
%解出E_k
syms x;
E_k=solve(x-e*sin(x)==M_k);
v_k=atan(sqrt(1-e^2)*sin(E_k)/cos(E_k-e));
%v_k=solve(((exp(1)+cos(x))/(1+exp(1)*cos(x)))==E_k);

Phi_k=v_k+omega;


delta_u_k=C_us*sin(2*Phi_k)+C_uc*cos(2*Phi_k);
delta_r_k=C_rs*sin(2*Phi_k)+C_rc*cos(2*Phi_k);
delta_i_k=C_is*sin(2*Phi_k)+C_ic*cos(2*Phi_k);

u_k=Phi_k+delta_u_k;
r_k=A*(1-e*cos(E_k))+delta_r_k;
i_k=i_0+delta_i_k+t_k*idot;

X_kt=r_k*cos(u_k);
y_kt=r_k*sin(u_k);

Omega_k=Omega_0+(Omega_dot-...
        Omega_e)*t_k-Omega_e*t_oe;

x_k=X_kt*cos(Omega_k)-y_kt*cos(i_k)*sin(Omega_k);
y_k=X_kt*sin(Omega_k)+y_kt*cos(i_k)*cos(Omega_k);
z_k=y_kt*sin(i_k);
p=[x_k y_k z_k]/1000;
return;