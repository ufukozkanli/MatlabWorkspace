clc,clear close all
%number of represation point
q=8;
a=linspace(0,5,q);
syms xx;
%Exponential Random Variable Function
lm=1;
pdf=(lm*exp(-lm*xx));
b=zeros(1,length(a)+1);

eps=1;
oldx=zeros(1,length(a)-1);
while(eps>10e-3)
    old_a=a;
    b(1)=0;
    b(end)=inf;
    for i=2:q
        b(i)=(a(i-1)+a(i))/2;
    end
    b
    for i=1:q
        a(i)=((lm*b(i) + 1)/(lm*exp(lm*b(i))) - (lm*b(i+1) + 1)/(lm*exp(lm*b(i+1))))/(1/exp(lm*b(i)) - 1/exp(lm*b(i+1)));
        %a(i)=int(xx*pdf,b(i+1),b(i))/int(pdf,b(i+1),b(i));
    end
    a
    eps=sum(abs(old_a-a))
end

