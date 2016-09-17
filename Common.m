clc, clear close all;
%%
syms x y z t r k l m n
q=int(int(int(2*x+2*y+3*z^2,z,0,4),y,0,2),x,0,2)
%%
fun = @(x,y,z) 2*x+2*y+3*z^2;
q = triplequad(fun,0,2,0,2,0,4)
%%
fun = @(x,y,z) x.^2.*sin(y);

q = int(int(int(x.^2.*sin(y),z,0,2*pi),y,0,pi),x,0,r)
%%
ezsurf('sqrt(4-x^2-y^2)')
%%
f1= sin(x);
f2= cos(x);


f3=diff(x);
A=[f2 f1 f3
  -f1 f2 0
   0  0  1]
%%
divF= inline ('2.*(x+y)','x','y','z')
divF(1,2,3)
%%
A=[x y 
   z t]

A=[x y z
   t r k
   l m n]
inv(A)
inv(A)*det(A)
det(A)
%%
x=5*sind(20)*cosd(-70);
y=5*sind(20)*sind(-70);
z=5*cosd(20);
A=[x,y,z]
%%
sym('1/3+2/9')
%%
syms theta phi R;
[x,y,z]=sph2cart(phi,(pi/2-theta),r);
simplify(x)
simplify(y)
simplify(z)
subs(z,4,6,8)
%[x,y,z]=sph2cart(deg2rad(330),deg2rad(90-120),8)
