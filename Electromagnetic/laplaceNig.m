function main()
clc,clear close all;
showrays(0, 0.2, 4, 0.8, 1, 2);
%showrays(0, 0.2, 4, 0.8, 1, 3)


function showrays(zs,xs,z0,x0,a,N)
Nx=1000;
z=linspace(zs,z0,Nx);
Nx=1000;
z=linspace(zs,z0,Nx);
mx=a;
my=x0;
if(mod(N,2)==1)
    rU=N*a+mx;
    rD=-((N-1).*a+my);
else
    rU=N*a+my;
    rD=-((N-1).*a+mx);
end
xU=linspace(xs,rU,length(z));
xD=linspace(xs,rD,length(z));
for i=1:N
    for j=1:length(xU)
        if( xU(j)>a)
            xU(j)=a-(xU(j)-a);
        end
        if(xD(j)<0)
            xD(j)=0-(xD(j)-0);
        end
        if( xD(j)>a)
            xD(j)=a-(xD(j)-a);
        end
        if(xU(j)<a)
            xU(j)=0-(xU(j)-0);
        end
    end
end

plot(z,xU,'r');
plot(z,xD,'r');

