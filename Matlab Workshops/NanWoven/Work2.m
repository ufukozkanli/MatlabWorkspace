clc,clear all,close all;
%cd('D:\Tubitak Server Files\Matlab Workshops\NanWoven\Pics')
RGB = imread('NonwovenFabric.jpg');

flatImg = double(reshape(RGB,size(RGB,1)*size(RGB,2),size(RGB,3)));
idx = kmeans(flatImg,2);
A=reshape(idx,size(RGB,1),size(RGB,2));
A(A==2)=0;
BW=logical(A);
imagesc(BW);


figure,
imshow(BW),
title('Binary Image');
BW = ~ BW;
figure,
imshow(BW),
title('Inverted Binary Image');
[B,L] = bwboundaries(BW);
STATS = regionprops(L, 'all'); % we need 'BoundingBox' and 'Extent'
% Step 7: Classify Shapes according to properties
% Square = 3 = (1 + 2) = (X=Y + Extent = 1)
% Rectangular = 2 = (0 + 2) = (only Extent = 1)
% Circle = 1 = (1 + 0) = (X=Y , Extent < 1)
% UNKNOWN = 0
figure,
imshow(RGB)
hold on

for i = 1 : length(STATS)
  W(i) = uint8(abs(STATS(i).BoundingBox(3)-STATS(i).BoundingBox(4)) < 0.1);
  W(i) = W(i) + 2 * uint8((STATS(i).Extent - 1) == 0 );
  centroid = STATS(i).Centroid;
  switch W(i)
      case 1
          plot(centroid(1),centroid(2),'bO');
      case 2
          plot(centroid(1),centroid(2),'bX');
      case 3
          plot(centroid(1),centroid(2),'bS');
  end
end
return