clc,clear all,close all;
%cd('D:\Tubitak Server Files\Matlab Workshops\NanWoven\Pics')
img = imread('NonwovenFabric.jpg');
BW2=im2bw(rgb2gray(img));
figure;imshow(BW2,[])

flatImg = double(reshape(img,size(img,1)*size(img,2),size(img,3)));
idx = kmeans(flatImg,2);
A=reshape(idx,size(img,1),size(img,2));
A(A==2)=0;
BW=~logical(A);
figure;imshow(BW,[])

[V,C]=sort(sum(~BW),'descend');
hold on
for i=1:100
    plot([C(i),C(i)],[1,size(BW,1)],'Color','r','LineWidth',V(i)/V(1)*2)
end
hold off
return;
[B,L,N,A] = bwboundaries(BW);
figure; imshow(BW); hold on;
for k=1:length(B),
    if(~sum(A(k,:)))
       boundary = B{k};
       plot(boundary(:,2),boundary(:,1),'r','LineWidth',2);
       for l=find(A(:,k))'
           boundary = B{l};
           plot(boundary(:,2),boundary(:,1),'g','LineWidth',2);
       end
    end
end
hold off