clc,clear close all
f=1;
Q=10;
VZero=10;
input=0:pi/1000:2*pi;

alfa=@(par)(2*pi*f*par*sqrt(1-(1/(4*Q^2))));

V=@(t)(VZero*exp(-pi*f*t/Q).*(cos(alfa(t))+(1/sqrt(4*Q^2-1)).*sin(alfa(t))));

output=V(input);

plot(input,output); hold on
points=zeros(100);
j=1;
for i=1:1:length(output)-1
    if(output(i)>0 && output(i+1)<0)
        points(j)=(output(i)+output(i+1))/2;
        input(i)
        output(i)
        scatter(input(i),points(j));
        j=j+1;
        
    end
end

grid on
