clc,clear all,close all;
a = randi(100,10,2);
a(:,3) = a(:,1) + a(:,2)
b = sortrows(a,1)
c = sortrows(b,2);
c(:,4) = sort(c(:,3))
[val ind] = min(c(:,[3 4]))
%%
x = randn(3,100);
boxplot([x])

