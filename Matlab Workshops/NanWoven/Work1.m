clc,clear all,close all;
%cd('D:\Tubitak Server Files\Matlab Workshops\NanWoven\Pics')
I = imread('NonwovenFabric.jpg');

flatImg = double(reshape(I,size(I,1)*size(I,2),size(I,3)));
idx = kmeans(flatImg,2);
imagesc(reshape(idx,size(I,1),size(I,2)));




number = 330;

figure
subplot(number + 1)
imshow(I,[]);
title('RGB');
impixelinfo;

G = rgb2gray(I);
subplot(number + 2)
imshow(G,[]);
title('GRAY');

A = imadjust(G);
subplot(number + 3)
imshow(A,[]);
title('ADJ');

E = histeq(G);
subplot(number + 4)
imshow(E,[]);
title('HISTEQ');

B = im2bw(G);
subplot(number + 5)
imshow(B,[]);
title('BIN');



figure

for i=0:0.01:0.04
ES = edge(G,'sobel',i);
subplot(number + 1)
imshow(ES,[]);
title('SOBEL');

EP = edge(G,'prewitt',i);
subplot(number + 2)
imshow(EP,[]);
title('prewitt');

ER = edge(G,'roberts',i);
subplot(number + 3)
imshow(ER,[]);
title('roberts');

EL = edge(G,'log');
subplot(number + 4)
imshow(EL,[]);
title('log');

EC = edge(G,'canny',i);
subplot(number + 5)
imshow(EC,[]);
title('canny');

drawnow;
pause(0.3);
end

%http://stackoverflow.com/questions/2001475/how-can-i-find-the-most-dense-regions-in-an-image
figure
%# Load and plot the image data:
imageData = imcomplement(G);  %# Load the lattice image
subplot(number + 1);
imshow(imageData);
title('Original');

i=31;
%for i=1:10
%# Gaussian-filter the image:
gaussFilter = fspecial('gaussian',[i i],9);  %# Create the filter
filteredData = imfilter(imageData,gaussFilter);
subplot(number + 2);
imshow(filteredData);
title('GAUSS');

opened = imopen(imageData,strel('rectangle',[3 8+i]));
subplot(number + 6);
imshow(opened,[])
title('opened');

drawnow;
%pause(0.5);
%end

Diff = imcomplement(G) - filteredData;

subplot(number + 3);
imshow(Diff,[])
title('ORG. - FILT.');

%# Perform a morphological close operation:
closeElement = strel('disk',31);  %# Create a disk-shaped structuring element
closedData = imclose(filteredData,closeElement);
subplot(number + 4);
imshow(closedData);
title('Closed image');

%# Find the regions where local maxima occur:
maxImage = imregionalmax(closedData);
maxImage = imdilate(maxImage,strel('disk',5));  %# Dilate the points to see %# them better on the plot

subplot(number + 5);
imshow(maxImage);
title('DENSE LOCS');

