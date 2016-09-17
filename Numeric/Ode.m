clc,close all,clear
syms s; syms t;
lhs = s^2 +0.5*t^2;
rhs = 1/s;
soln = simplify(ilaplace(rhs*1/lhs))

t=-10:0.01:10;
ezplot(soln)
%plot(t,subs(soln,t))