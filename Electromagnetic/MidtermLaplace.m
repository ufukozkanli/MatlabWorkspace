function main()
clc,clear close all;
[z,u]=laplace(0,1,10,-30,11,Inf);
exact=(-40.*z)+10;
clf;
plot(z,exact,'r');hold on;
plot(z,u,'g');ylabel('Volt');xlabel('Region')
legend('Analytical','Laplace');



function [z,u]=laplace(a,b,ua,ub,N,Nit)
u=zeros(1,N);
u(1)=ua;
u(N)=ub;
z=linspace(a,b,N);
for i=1:Nit    
    uTemp=u;
    %u=(u(1:end-2)-2.*u(2:end-1)+u(3:end))./(interval^2)
    u(2:end-1)=(u(1:end-2)+u(3:end))./2;   %second derivative equals zero 
    plot(z,u,'r');ylabel('Volt');xlabel('Region');
    title(sprintf('Volt-Region Iteration (%d)',i));
    pause(0.02);
    if(sum(abs(u-uTemp))<=1e-003)
        break;
    end
    %[ua u ub]
end
fprintf('Number of iteration %d\n',i)
