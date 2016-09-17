clear all, close all,clc
dx=0.05;
x=0:dx:1;
Ke=1/dx*[1 -1;-1 1];
Me=dx/6*[2 1;1 2];
K=zeros(length(x));
M=zeros(length(x));
F=zeros(length(x),1);

syms xx
f=xx^3+6*xx+(0.25*pi^2-1)*sin(pi/2*xx);

for i=1:length(x)-1
    % i=1  x(1)  x(2)
    % i=2  x(2)  x(3)
    K(i:i+1,i:i+1)=K(i:i+1,i:i+1)+Ke;
    M(i:i+1,i:i+1)=M(i:i+1,i:i+1)+Me;
     B1=(x(i+1)-xx)/dx;
     B2=(xx-x(i))/dx;
     
     F(i)=F(i)+double(int(f*B1,xx,x(i),x(i+1)));
     F(i+1)=F(i+1)+double(int(f*B2,xx,x(i),x(i+1)));
     
end
K=K(2:end-1,2:end-1);
M=M(2:end-1,2:end-1);
F=F(2:end-1);

plot(x,[0 ((-K+M)\F).' 0]);hold on
plot(x,x.^3-sin(pi/2*x),'r--');
legend('fem','exact')

fexc=x.^3-sin(pi/2*x);
fapp=[0 ((-K+M)\F).' 0];

figure
plot(x,abs(fapp-fexc)./fexc)