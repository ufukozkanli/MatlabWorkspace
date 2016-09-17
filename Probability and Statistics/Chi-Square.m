%%
clc,clear all, close all;
x = 0:0.2:15;
y = chi2pdf(x,4);
plot(x,y)

%%
for i=1:10
x = 0:0.2:15;
y = chi2pdf(x,i);
plot(x,y)
pause(1)
hold on
end
%%
%X^2 for  alpha=0.05  D.F.=2
chi2inv(1-0.05,2)

%%
o=[7 14 6 10 8 4 5 6 12 8];
%expected
leno=length(o);
e=ones(1,leno)*sum(o)/leno;
%
difs=((o-e).^2)./e;
chi=sum(difs(:) )
chi2inv(1-0.05,length(e)-1)

%%
%Check and find probability for given X^2 value
1-chi2cdf(5.9915,2)
%%
x=[
31 14 45;
2  5  53; 
53 45 2;
];
[h,p] = chi2gof(x(:),'Alpha',0.01)

%%
%Contigency Tables

o=[82 446 355
    46 574 273];
smc=sum(o)
smr=sum(o')
e=smr'*smc./sum(o(:))



%
difs=((o-e).^2)./e;
chi=sum(difs(:) )
chi005=chi2inv(1-0.05,prod(size(e)-1))

pval=1-chi2cdf(chi,prod(size(e)-1))