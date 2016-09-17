clc,clear close all
a=[6, 1,1,
		4,-2,5,
		2,8,7]
    det(a)
b=[1:5;1:5;1:5;1:5;1:5]

return

f=@(x)((x.^4+3.*x.^1+15));
a=1:101;
fa=f(a)
fTemp=fa;
for i=1:4
  fTemp=fTemp(2:2:end)-fTemp(1:2:end-1)  
end
