%%HAND RECOGNIZING
clc,clear all,close all;
%Read the image, and capture the dimensions
tic;
img_orig = imread('hand.png');
height = size(img_orig,1);
width = size(img_orig,2);

%Initialize the output images
out = img_orig;
bin = zeros(height,width);

%Convert the image from RGB to YCbCr
img_ycbcr = rgb2ycbcr(img_orig);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);


%Detect Skin
[r,c,v] = find(Cb>=67 & Cb<=137 & Cr>=133 & Cr<=173);
numind = size(r,1);
numcol = size(r,2);

%Mark Skin Pixels
for i=1:numind
    out(r(i),c(i),:) = [0 0 255];
    bin(r(i),c(i)) = 1;
end

% Detect radius
[x1,y1] = find(out(:,:,3) == 255, 1,'first');
[x2,y2] = find(out(:,:,3) == 255, 1, 'last');

% Detect Hand Center
hits = 0;
hitsArr = zeros(1,height);
for i = 1:height
    hits = numel(find(bin(i,:) == 1));
    hitsArr(i) = hits;
end
maxHitr = max(hitsArr);
y =  find(hitsArr == maxHitr,1,'first');

hitsArr = zeros(1,width);
for i = 1:width
    hits = numel(find(bin(:,i) == 1));
    hitsArr(i) = hits;
end
maxHitc = max(hitsArr);
x = find(hitsArr == maxHitc,1,'first');

label = 'Hand';
position = [x y abs(y2-y1)/2; x y 1];
img_out = insertObjectAnnotation(img_orig,'Circle',position,label);
imshow(img_orig);
figure; imshow(img_out);title('Detected hand');
imwrite(img_out,'hand_detect.jpg');
% viscircles([x y],abs(y2-y1)/2,'EdgeColor','r');
% viscircles([x y],1,'EdgeColor','r');
% figure; imshow(out);
figure; imshow(bin);
toc;