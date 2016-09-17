function main
%cd('C:/Users/NobodyAir/Desktop/Temp/matlab')
clc, clear,imtool close all ,close all
c();

function c
I = imread('pout.tif');
J = imadjust(I);


%im=imread('pout.tif');
%imshow(drawOvalFill(im, [50 50 53 53], 255))
%imshow(drawOvalFrame(im, [50 50 90 90], 0.5, 255))
%imshow(drawPolygon(im, [10 10 ; 90 30 ;  90 90], 255))
%imshow(drawRectFill(im, [20 20 50 50], 255))
imshow(drawRectFrame(im, [20 20 50 50], 1,255))


function [img] = RippleImageGenerato( ticks,DIMX,DIMY )


imgSize = [DIMY,DIMX];
img=uint8(ones(imgSize));

for i=1:imgSize(2)
    for j=1:imgSize(1)
        fx = i - DIMX/2;
        fy = j - DIMY/2;
        d = sqrt( fx^2 + fy^2 );
        grey = floor( 128.0 + 127.0 *  cos(d/10.0 - ticks/7.0) /(d/10.0 + 1.0) );
        img(j,i)=grey;
    end
    
end
img=ind2rgb(img,gray(256));


function a
close all;
I=uint8(rand(300,500)*256+72);
figure
imshow(I);
figure
imshow(I,[]);
figure
I=imread('a.tif');
imshow(I,[])
%imwrite(I,gray(256),'a.tif')
%imwrite(I,'b.tif')
return


clc,clear all,close all;
o=[252 255 162 331];
e=[228 239 176 357];
a=(e-o)'
b=(a.^2)
c=b./o'

sum(c)
norminv([0.025 0.975],0,1)
3250-  norminv([0.025 0.975],0,1) .* sqrt(1000)/sqrt(12)

load census
plot(cdate,pop,'ro')
dfittool

a=imread('C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test2\00020359.bmp');
b=imread('C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test2\00020360.bmp');
a=im2double(a);
b=im2double(b);
c = (a.^2 + b.^2).^0.5;
figure
imshow(a,[]);
figure
imshow(b,[]);
figure
imshow(c,[]);

imshow(a,[]);
b=histeq(a);
figure
imshow(b,[]);
figure
imhist(a)
figure
imhist(b)

for i=0:8
    figure
    b=a / (2^i);
    %imshow(b,[]);
    imshow(b-a,[])
end



