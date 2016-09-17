clc ,clear close all;
%tic;
%x=rand(1,1000);
%y=exp(-x.^2/2)/sqrt(2*pi);
y=randn(1,10000)*5;
yTemp=zeros(size(y));
aInterval=0:1000;
mse=zeros(1,101);
for a=aInterval
    a2=a/100;
    for i=1:length(y)
        yTemp(i)=y(i);
        if(yTemp(i)<-a2)
            yTemp(i)=-2*a2;
        elseif(-a2<=yTemp(i) && yTemp(i)<=a2)
            yTemp(i)=0;
        elseif(yTemp(i)>a2)
            yTemp(i)=2*a2;
        end
    end
    yTemp;
    mseTemp=mean((y-yTemp).^2);
    mse(a+1)=mseTemp;
end
%toc
%figure(1); hold on 
plot(aInterval/100,mse);