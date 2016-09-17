clc,clear close all
q=8;%number of represation point
a=linspace(0,20,q);
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
    %eps=sum(abs(old_a-a))
end


return;


clc,clear close all
for i=1:20
    lam=i;
    NofRepP=8;%number of represation point
    expRandpdf=@(x)(lam*exp(-lam*x));
    x = expRandpdf(0:20);
    [partition,codebook] = lloyds(x,NofRepP);
    plot(partition); hold on
end
return

clc,clear close all
t = [0:.1:2*pi];
sig = sin(t);
partition = [-1:.2:1];
codebook = [-1.2:.2:1];
% Now optimize, using codebook as an initial guess.
[partition2,codebook2] = lloyds(sig,codebook);
[index,quants,distor] = quantiz(sig,partition,codebook);
[index2,quant2,distor2] = quantiz(sig,partition2,codebook2);
% Compare mean square distortions from initial and optimized
[distor, distor2] % parameters.
return






clc,clear close all
tic
a=load('C:\Users\NobodyAir\Desktop\Google Drive\Courses\Parallel Programming\Tools\MPI_Tutorial_1\MPI_Tutorial_1\matrix.800.txt');
a=reshape(a,800,800);
det(a)
toc
return

f=@(x)((x.^4+3.*x.^1+15));
a=1:101;
fa=f(a)
fTemp=fa;
for i=1:4
    fTemp=fTemp(2:2:end)-fTemp(1:2:end-1)
end



