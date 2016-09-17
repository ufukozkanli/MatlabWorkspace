clear all,close all,clc;
%solve the wave equation
%phi_tt=phi_xx t>0
%phi(0,t)=phi(1,t)=0 t>0
%phi(x)=sin(pi*x) ad t=0
%phi_t(x)=0 0<x<1
u=1;
dx=0.1;
r=1;
dt=sqrt(r)*dx/u;

x=0:dx:1;  %0<x<1
phi=sin(pi*x);  %at t=0
plot(x,phi);


phinext=phi(1:end-2);    %at t=dt
for j=0:100
    phiexc=sin(pi*x)*cos(pi*dt*j);
    plot(x,phi);hold on, plot(x,phiexc,'r--');
    title(['The function at time t=',num2str(j*dt)]) 
    hold off
    %pause
    phinextt=[0 phinext(1:end-2)+phinext(3:end)-phi(2:end-1) 0];
    phi=phinext;
    phinext=phinextt;
end
