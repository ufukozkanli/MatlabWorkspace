x=-10:0.1:10;
y=exp(-x.^2/2)/sqrt(2*pi);
for a=0:10
    for i=1:length(x)
        xc=x(i);
        if(xc<-a)
            yc(i)=-2*a;
        elseif(-a<=xc && xc<a)
            yc(i)=0;
        else
            yc(i)=2*a;
        end
    end
    mse(a+1)=mean((y-yc).^2);
end
plot(0:10,mse)