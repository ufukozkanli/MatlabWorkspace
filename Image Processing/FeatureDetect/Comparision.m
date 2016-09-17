clc,clear all,close all;
N=2;
a=rand(N,N);
b=rand(N,N);
c=zeros(2*N-1,2*N-1);
d=zeros(2*N-1,2*N-1);

cc = xcorr2(b,a)

for i=1:2*N-1
    for j=1:2*N-1
        sum=0;
        for k=1:N			
            for m =1:N			
                rw=(i+k-(N-1))-1;
                cl=(j+m-(N-1))-1;
                if(rw>0 && cl>0 && rw<=N && cl<=N)
                    sum=sum+a(k,m) * b(rw,cl);
                end					
            end
        end		
        c(i,j)=sum;
    end
end
c

for i=1:2*N-1
    for j=1:2*N-1
        sum=0;
        for k=1:N			
            for m =1:N			
                rw=(i+k-(N-1))-1;
                cl=(j+m-(N-1))-1;
                if(rw>0 && cl>0 && rw<=N && cl<=N)
                    sum=sum+(a(k,m) - b(rw,cl))^3;
                end					
            end
        end		
        d(i,j)=sum;
    end
end
d


[max_cc, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1))
corr_offset = [ (ypeak-size(b,1)) (xpeak-size(b,2)) ];

[max_cc, imax] = min(abs(d(:)));
[ypeak, xpeak] = ind2sub(size(d),imax(1))
corr_offset = [ (ypeak-size(b,1)) (xpeak-size(b,2)) ];



return
c==cc
isequal(c,cc)