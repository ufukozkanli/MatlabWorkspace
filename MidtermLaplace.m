function main()
clc,clear close all;
[u,z]=laplace5(0,1,10,-30,1001,1000000);
plot(u,z);


function [z,u]=laplace5(a,b,ua,ub,N,Nit)
u=zeros(1,N);
u(1)=ua;
u(N)=ub;
z=linspace(0,1,N);
for i=1:Nit
    %u=(u(1:end-2)-2.*u(2:end-1)+u(3:end))./(interval^2)
    u(2:end-1)=(u(1:end-2)+u(3:end))./2;
    %[ua u ub]
end


function [z,u]=laplace1(a,b,ua,ub,N,Nit)
interval=(b-a)/(N-1);
z=linspace(0,1,N);
u=linspace(ua,ub,N)


function [z,u]=laplace2(a,b,ua,ub,N,Nit)
interval=(b-a)/(N-1);
z=linspace(0,1,N);
i=0;
u=-40*(z)+10;

u=ones(length(z),2);
while(i<Nit)
    i=i+1;
    u=(u(1:end-2)-2.*u(2:end-1)+u(3:end))./(interval^2)
end




function [z,u]=laplace3(a,b,ua,ub,N,Nit)
interval=(b-a)/(N-1);
z=linspace(0,1,N);
u(1)=ua;
u(Nit)=ub;
tempU=u;
for i=2:Nit-1
    tempU(i)=tempU(i-1)-2*tempU(i)+tempU(i+1);
    if(tempU(i)-u(i)==0.001)
        break;
    end
end


% function [z,u]=laplace4(a,b,ua,ub,N,Nit) 
% V1(1)=0;
% V2(1)=0;
% V3(1)=0;
% V4(1)=0;
% V5(1)=0;
% V6(1)=0;
% for j=1:Nit
%     V1(j+1)=(10+V2(j)+V3(j))/4;
%     V2(j+1)=(10+V1(j)+V1(j)+V4(j))/4;
%     V3(j+1)=(V1(j)+V4(j)+V5(j))/4;
%     V4(j+1)=(V3(j)*2+V2(j)+V6(j))/4;
%     V5(j+1)=(V3(j)+V6(j))/4;
%     V6(j+1)=(V4(j)+V5(j)*2)/4;
% end
% u=[(1:Nit+1)', V1',V2',V3',V4',V5',V6']