clc,clear close all;
interval=0.01;
node=101;
u=zeros(node,1);
u(1)=10;
u(10)=-30;
for i=1:101
    u=(u(1:end-2)-2.*u(2:end-1)+u(3:end))./(interval^2)
end