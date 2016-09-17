function main
clc, clear,imtool close all ,close all
params(1)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test1\exp1_001_b.bmp'};
params(2)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test1\exp1_001_c.bmp'};
%sumImages(params);
%interpolation(params);
%resizing(params);
%gaussianlowPass(params)
edge();

function edge
I = imread('bag.png');
imshow(I,[]);





function resizing(params)
[a map] = imread(cell2mat(params(1)));
b = imresize(a, 0.5,'bilinear',100);
imshow(a);
figure
imshow(b);
function gaussianlowPass(params)
a=imread(cell2mat(params(1)));
figure
imshow(a);
figure
b=imfilter(a,fspecial('gaussian',10,20));
imshow(b);
figure
imshow(a-b);

function interpolation(params)

a=imread(cell2mat(params(1)));
b=imread(cell2mat(params(2)));
%z(:,:,1)=a;
%z(:,:,2)=b;
z=double(a-b);
[x,y]=size(a);
p=50;
dx=linspace(1,20*x,p);
dy=linspace(1,20*y,p);
%p=1;
%dx=1:p:x;
%dy=1:p:y;

[px,py]=gradient(z);

%imshow(a);hold on,
%quiver(1:10,1:10,ones(size(a)),ones(size(a))), hold off
%quiver(dy,dx,px,py), hold off
figure
quiver(dy,dx,px(1:p,1:p),py(1:p,1:p))

function sumImages(params)
a=imread(cell2mat(params(1)));
b=imread(cell2mat(params(2)));
%imshow(a);
%figure;
%imshow(b);
%figure
%imshow(a+b);
%figure
imshow(a-b);
figure
imshow(circshift(a,[5,0])-b);
figure
return
sumV=99999999;
for i=-10:10
    for j=-10:10
        d=circshift(a,[i,-j])-b;
        sumC=sum(sum(d));
        if(sumV>sumC)
            sprintf('%d %d %d',i,j,sumV)
            sumV=sumC;
        end
        imshow(d);        
        %pause(0.5);
    end
end


