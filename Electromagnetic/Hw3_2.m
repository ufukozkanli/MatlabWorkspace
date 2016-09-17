clear all, close all,clc
dx=0.25;
x=0:dx:1
Ke=1/dx*[1 -1 0;-1 2 -1;0 -1 1]
Me=dx/6*[2 1 0 0;1 4 0 0;0 1 4 0;0 0 1 2];
K=zeros(length(x));
M=zeros(length(x));
F=zeros(length(x),1);

syms xx
f=xx^3+6*xx+(0.25*pi^2-1)*sin(pi/2*xx)


for i=1:length(x)-3
    % i=1 x(1) x(2)
    % i=2 x(2) x(3)
    K(i:i+2,i:i+2)=K(i:i+2,i:i+2)+Ke;
    M(i:i+3,i:i+3)=M(i:i+3,i:i+3)+Me;
    %B1=(x(i+1)-xx)/dx;
    %B2=(xx-x(i))/dx;
    B1=((xx-x(i+1))*(xx-x(i+2))*(xx-x(i+3)))/(-dx*-2*dx*-3*dx)
    B2=((xx-x(i))*(xx-x(i+2))*(xx-x(i+3)))/(dx*-dx*-2*dx)
    B3=((xx-x(i))*(xx-x(i+1))*(xx-x(i+3)))/(2*dx*dx*-dx)
    B4=((xx-x(i))*(xx-x(i+1))*(xx-x(i+2)))/(3*dx*2*dx*dx)
%        n1=((x-x2)*(x-x3)*(x-x4))/((x1-x2)*(x1-x3)*(x1-x4))
%     n2=((x-x1)*(x-x3)*(x-x4))/((x2-x1)*(x2-x3)*(x2-x4))
%     n3=((x-x1)*(x-x2)*(x-x4))/((x3-x1)*(x3-x2)*(x3-x4))
%     n4=((x-x1)*(x-x2)*(x-x3))/((x4-x1)*(x4-x2)*(x4-x3))
    Fe(1)=double(int(f*B1,xx,x(i),x(i+1)));
    Fe(2)=double(int(f*B2,xx,x(i),x(i+1))); 
    Fe(3)=double(int(f*B3,xx,x(i),x(i+1)));
    Fe(4)=double(int(f*B4,xx,x(i),x(i+1))); 
    
    F(i)=F(i)+double(int(f*B1,xx,x(i),x(i+1)));
    F(i+1)=F(i+1)+double(int(f*B2,xx,x(i),x(i+1)));
    F(i+2)=F(i+2)+double(int(f*B3,xx,x(i),x(i+1)));
    F(i+3)=F(i+3)+double(int(f*B4,xx,x(i),x(i+1)));
    %pause
end
K=K(2:end-1,2:end-1)
M=M(2:end-1,2:end-1)
F=F(2:end-1)

plot(x,[0 ((-K+M)\F).' 0],'r-'); hold on;

plot(x,x.^3-sin(pi/2*x),'g-')
legend('fem','exact');

%figure
%fexc=x^3-sin(pi/2*x);

%u=xx^3-sin(pi/2*xx);
%diff(u,xx,2)+u;