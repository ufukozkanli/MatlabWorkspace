x0=0;
x1=1;
dx=0.2;
dt=0.04;
x=x0:dx:x1;
[m,n]=size(x);
A=100*ones(m,n);
A(1)=50;
A(end)=50;
for j=1:10
    display(j);
end