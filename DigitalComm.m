clc ,clear close all;
x=-10:0.1:10;
y=exp(-x.^2/2)/sqrt(2*pi);
for a=0:10
    for i=1:length(x)
        xTemp=x(i);
        if(xTemp<-a)
            yTemp(i)=-2*a;
        elseif(-a<=xTemp && xTemp<a)
            yTemp(i)=0;
        elseif(xTemp>a)
            yTemp(i)=2*a;
        end
    end
    mse(a+1)=mean((y-yTemp).^2);
end
plot(0:10,mse)