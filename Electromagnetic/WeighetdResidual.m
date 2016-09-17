%1.Eigen Rays 
%1.

clear all, clc, close all
dx=0.1;
x=0:dx:1;
%syms x
c1=1/8;
c2=1/8*tan(2)+1/(4*cos(2));
uex=c2*sin(2*x)+c1*cos(2*x)+0.25*x.^2-1/8;
%diff(uex,x,2)+4*uex-x^2
%break
syms xx a1 a2
phia=xx+a1*xx*(xx-2)+a2*xx^2*(xx-3/2);
R=diff(phia,xx,2)+4*phia-xx^2;

% point matching method
x1=1/3; x2=2/3;
R1=subs(R,xx,x1);
R2=subs(R,xx,x2);
[an1,an2]=solve(R1,R2);
phipnt=subs(phia,{a1,a2,xx},{double(an1),double(an2),x});

%subdomain method
R1=int(R,xx,0,1/2);
R2=int(R,xx,1/2,1);
[an1,an2]=solve(R1,R2);
phisub=subs(phia,{a1,a2,xx},{double(an1),double(an2),x});

% Galerkin method
w1=xx*(xx-2);
w2=xx^2*(xx-3/2);
R1=int(w1*R,xx,0,1);
R2=int(w2*R,xx,0,1);
[an1,an2]=solve(R1,R2);
phigal=subs(phia,{a1,a2,xx},{double(an1),double(an2),x});

%least squares method
w1=diff(R,a1);
w2=diff(R,a2);
R1=int(w1*R,xx,0,1);
R2=int(w2*R,xx,0,1);
[an1,an2]=solve(R1,R2);
philst=subs(phia,{a1,a2,xx},{double(an1),double(an2),x});

% plot results
plot(x,uex),xlabel('x');ylabel('phi(x)'), hold on
plot(x,phipnt,'r')
plot(x,phisub,'g--')
plot(x,phigal,'k-.')
plot(x,philst,'y')
legend('Exact','Point match','subdomain','galerkin','leastsquare')