function Birge_Vieter
clc, clear, close all
p=zeros(1,6);
ply=p;
q=p;
flag=0;
fprintf('\t\tBIRGE-VIETA METHOD');
fprintf('\n Enter the highest degree of the equation (max 5): ');
m=3;
p=[1 -1 -1 1]

ply=[p 0 0]
r=0.5
x = 0.5;
while(flag~=1)
    fprintf('\n%f\n',x);
    fx = synth(m,x,p,q);
    for i=1:m
        p(i)=q(i);
    end
    fdx = synth(m-1,x,p,q);
    x1 = x - (fx/fdx);

    if (abs(x1-x)<= 0.0009)
        flag = 1;
    end
    x = x1;

    for i=1:5
        p(i)=ply(i);
    end
end


fprintf('\nApproximate root = %f', x1);


function gm=synth(m, r,p,q)
    q(1) = p(1);
for i=2:m+1
    q(i) = (q(i-1)*r)+p(i);
end

fprintf('\n');
for i=1:m
    fprintf('\t%f',q(i));
end
    fprintf('\t%f',q(m));
gm=q(m);

%function [root,yRoot,err,it,P] = BirgeVieta(coff , x0 , delta)
coff=[1 -1 -1 1] , x0=0.5 , delta=0.01
% Inputs
%   coff    coffetient of the polynomial
%   a       Starting point
%   delta   convergence tolerance
% Return
%   root    solution: the root
%   yRoot   function value at root
%   err     error estimate in root
%   it      number of iterations
%   P       History vector of the iterations
err = 1 + delta;
x = x0;
bi = 0; ci = 0; it = 0;
coffLen = length(coff);
P = zeros(1, 1);
P(1) = x0;

while err > delta ,
        it = it + 1;
        x0 = x;
        bi = 0;ci = 0;
        for i=1:coffLen-1,
                bi = bi * x + coff(i);
                ci = ci * x + bi;
        end
        bi = bi * x + coff(coffLen);
        x = x - (bi / ci);
    P = [P;x];
        err = abs(x - x0);
end
root  = x;
yRoot = polyval(coff,root);
root,yRoot,err,it,P
%end
