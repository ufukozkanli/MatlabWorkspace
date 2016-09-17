function main()
clc,clear close all
StiffnessAndMass(3)


function StiffnessAndMass(degree)
syms x x1 x2 x3 x4
if(degree==1)
    n1=(x2-x)/(x2-x1);
    n2=(x-x1)/(x2-x1);
    k11=int(diff(n1,x)^2,x,x1,x2)
    k12=int(diff(n1,x)*diff(n2,x),x,x1,x2)
    %Mass functionda diffler ç?kacak
    f11=int(n1^2,x,x1,x2);
    f12=int(n1*n2,x,x1,x2);
elseif(degree==2)
    n1=((x-x2)*(x-x3))/((x1-x2)*(x1-x3))
    n2=((x-x1)*(x-x3))/((x2-x1)*(x2-x3))
    n3=((x-x1)*(x-x2))/((x3-x1)*(x3-x2))
    
    k11=int(int(diff(n1,x)^3,x,x1,x2),x,x2,x3)
    k12=int(int(diff(n1,x)*diff(n2,x),x,x1,x2),x,x2,x3)
    k22=int(int(diff(n1,x)*diff(n2,x)*diff(n3,x),x,x1,x2),x,x2,x3)
    
    f11=int(int(n1^3,x,x1,x2),x,x2,x3)
    f12=int(int(n1*n2,x,x1,x2),x,x2,x3)
    f22=int(int(n1*n2*n3,x,x1,x2),x,x2,x3)    
    
elseif(degree==3)
    n1=((x-x2)*(x-x3)*(x-x4))/((x1-x2)*(x1-x3)*(x1-x4))
    n2=((x-x1)*(x-x3)*(x-x4))/((x2-x1)*(x2-x3)*(x2-x4))
    n3=((x-x1)*(x-x2)*(x-x4))/((x3-x1)*(x3-x2)*(x3-x4))
    n4=((x-x1)*(x-x2)*(x-x3))/((x4-x1)*(x4-x2)*(x4-x3))
    
    k11=int(int(int(diff(n1,x)^4,x,x1,x2),x,x2,x3),x,x3,x4)
    k12=int(int(int(diff(n1,x)*diff(n2,x),x,x1,x2),x,x2,x3),x,x3,x4)
    k13=int(int(int(diff(n1,x)*diff(n2,x)*diff(n3,x),x,x1,x2),x,x2,x3),x,x3,x4)
    k14=int(int(int(diff(n1,x)*diff(n2,x)*diff(n3,x)*diff(n4,x),x,x1,x2),x,x2,x3),x,x3,x4)
    
    
end




