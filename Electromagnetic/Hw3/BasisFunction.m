function main()
clear all, close all,clc
FindBasis(2)

function FindBasis(degree)
syms x x1 x2 x3 x4
dx=0.25
if(degree==2)
    n1=((x-x2)*(x-x3))/((x1-x2)*(x1-x3))
    n2=((x-x1)*(x-x3))/((x2-x1)*(x2-x3))
    n3=((x-x1)*(x-x2))/((x3-x1)*(x3-x2))
    
elseif(degree==3)
    n1=((x-x2)*(x-x3)*(x-x4))/((x1-x2)*(x1-x3)*(x1-x4))
    n2=((x-x1)*(x-x3)*(x-x4))/((x2-x1)*(x2-x3)*(x2-x4))
    n3=((x-x1)*(x-x2)*(x-x4))/((x3-x1)*(x3-x2)*(x3-x4))
    n4=((x-x1)*(x-x2)*(x-x3))/((x4-x1)*(x4-x2)*(x4-x3))
end
n1=subs(n1,{x1,x2,x3,x4},{0,1,2,3})
n2=subs(n2,{x1,x2,x3,x4},{0,1,2,3})
n3=subs(n3,{x1,x2,x3,x4},{0,1,2,3})

if(degree==3)
    n4=subs(n4,{x1,x2,x3,x4},{0,1,2,3})
end
n1
n2
n3
a=0:dx:2;
if(degree==3)
    n4
    a=0:dx:3;
end

ay1=subs(n1,x,a);
ay2=subs(n2,x,a);
ay3=subs(n3,x,a);

if(degree==3)
    ay4=subs(n4,x,a)
end
plot(a,ay1,'r--'); hold on
plot(a,ay2,'g--');
plot(a,ay3,'b--');
if(degree==3)
    plot(a,ay4,'y--');
end
