function main()
clc,clear close all;
[u,z]=laplace(0,1,10,-30,1001,100)
plot(u(2:end-1),z(2:end-1))

function [z u] = laplace (a, b, ua, ub, N, Nit) 
dz = (b-a)/N; 
z = 0:dz:1;
ua = 10 
ub = -30 
u = -40*z + 10 ;
diff=-40*z+10;
next = [0 diff(1:N)];
 
for j  = 1:Nit 
    ph = [0 next(1:N-1)+next(3:N+1)/2 0];     
    diff = next;    
end