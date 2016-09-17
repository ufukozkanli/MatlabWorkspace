
function main
%load mandrill;
%load clown 
%load detail 
%load durer 
%load flujet 
%load gatlin 
%help imdemos
clc, clear,imtool close all ,close all
global vid;
%quivermTest();
%webcam();
crossCor();
%wavelets()
%colorImage()
%rgbcube()
%imageTransform()
%fourier()
%edgedetect();
%myfilter();
%intense();
%basic()
%basic2()
%sinus();
%imadjustTest();
%imHistTest();
function quivermTest()
imshow('tire.tif')
lat0 = [50 39.7]; lon0 = [-5.4 2.9];
u = [5 5]; v = [3 3];
res=[0 0 1 1];
quiverm(res,2,'g','LineWidth',1);
%quiverm(lat0,lon0,u,v,'r','LineWidth',1)

function webcam()
global vid;
% Create a video input object.
vid = videoinput('winvideo');

%preview(vid);
%return;

set(vid, 'ReturnedColorSpace', 'RGB');
set(vid,'FramesPerTrigger',Inf);
set(vid,'TriggerRepeat',100);
figure;

start(vid)
%while(vid.FramesAvailable>1

try
    while(vid.FramesAcquired<100)
        FramesAvailable=vid.FramesAvailable
        FramesAcquired= vid.FramesAcquired        
        TriggerRepeat=vid.TriggerRepeat
        TriggersExecuted=vid.TriggersExecuted
        %vid.FramesAvailable
        [frames,time] = getdata(vid, get(vid,'FramesAvailable'));
        %[data time] = getdata(vid,2);

        %elapsed_time = time(2) - time(1);        
        %imshow(frames(:,:,:,1));
        %size_frame=size(frames,4)
        I=frames(:,:,:,1);
        figure(1),imshow(I);
        if(size(I,1)>0)
            %[face_a,skin_region]=faceDetect(I);
            %subplot(1,2,2),imshow(face_a);
            faceSkin(I);
        end
            
        
        drawnow;
    end
catch err    
    delete(vid)
    clear vid
    rethrow(err)
end
 delete(vid)
    clear vid

function faceSkin(I)
%imshow(I)
cform = makecform('srgb2lab');
J = applycform(I,cform);
%figure(2);imshow(J);
figure(2);imshow(J(:,:,1));
figure(3);imshow(J(:,:,2));
figure(4);imshow(J(:,:,3));
L=graythresh(J(:,:,2));
BW1=im2bw(J(:,:,2),L);
%figure(4);imshow(BW1);
M=graythresh(J(:,:,3));
%figure(5);imshow(J(:,:,3));
BW2=im2bw(J(:,:,3),M);
%figure(6);imshow(BW2);
O=BW1.*BW2;
% Bounding box
P=bwlabel(O,8);
BB=regionprops(P,'Boundingbox');
BB1=struct2cell(BB);
BB2=cell2mat(BB1);

% [s1 s2]=size(BB2);
% mx=0;
% for k=3:4:s2-1
%     p=BB2(1,k)*BB2(1,k+1);
%     if p>mx & (BB2(1,k)/BB2(1,k+1))<1.8
%         mx=p;
%         j=k;
%     end
% end
% figure(7),imshow(I);
% hold on;
% rectangle('Position',[BB2(1,j-2),BB2(1,j-1),BB2(1,j),BB2(1,j+1)],'EdgeColor','r' )
figure(1)
for i=1:size(BB,1)
    rectangle('Position', BB(i).BoundingBox);
end


function [face_a,skin_region]=faceDetect(I)

skin_region=skin(I);

se = strel('disk',5);
se2 = strel('disk',3);
er = imerode(skin_region,se2);
cl = imclose(er,se);
dil = imdilate(cl,se);        % morphologic dilation
dil = imdilate(dil,se); 
cl2 = imclose(dil,se);
d2 = imfill(cl2, 'holes');   % morphologic fill
facearea = bwdist(~d2);            % computing minimal euclidean distance to non-white pixel 
% figure;imshow(facearea,[]);

% imshow(d2);
face(:,:,1)=double(I(:,:,1)).*d2;   
face(:,:,2)=double(I(:,:,2)).*d2; 
face(:,:,3)=double(I(:,:,3)).*d2; 
face_a=uint8(face);

function segment=skin(I)

I=double(I);
[hue,s,v]=rgb2hsv(I);

cb =  0.148* I(:,:,1) - 0.291* I(:,:,2) + 0.439 * I(:,:,3) + 128;
cr =  0.439 * I(:,:,1) - 0.368 * I(:,:,2) -0.071 * I(:,:,3) + 128;
[w h]=size(I(:,:,1));

for i=1:w
    for j=1:h            
        if  140<=cr(i,j) & cr(i,j)<=165 & 140<=cb(i,j) & cb(i,j)<=195 & 0.01<=hue(i,j) & hue(i,j)<=0.1     
            segment(i,j)=1;            
        else       
            segment(i,j)=0;    
        end    
    end
end

% imshow(segment);
im(:,:,1)=I(:,:,1).*segment;   
im(:,:,2)=I(:,:,2).*segment; 
im(:,:,3)=I(:,:,3).*segment; 
% figure;imshow(uint8(im));


function crossCor()
clc,clear all,close all;
a=[1 2 3;1 2 3;1 2 3];
b=[5 6 7;1 2 3;1 2 3];

cc=xcorr2(b,a)
[max_cc, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1))

corr_offset = [(xpeak-size(a,2)) 
               (ypeak-size(a,1))]

return
yr=magic(5)
y2r=[ones(1,5);yr];
y2r=[ones(6,2),y2r];
%y2r(1,:)=ones(1,5);
%y2r(:,1)=ones(1,5);
y2r
cc=xcorr2(yr,y2r);
figure, surf(cc), shading flat
[max_cc, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1))

corr_offset = [(xpeak-size(y2r,2)) 
               (ypeak-size(y2r,1))]

xoffset = corr_offset(1);
yoffset = corr_offset(2);


function wavelets()
f = imread('Clown.tif');
figure, imshow(f, []);
F = fftshift(fft2(double(f)));
S = log(abs(F));
%imwrite( S/max(S(:)), 'mask.tif');
M = imread('mask.tif');
M = M(:,:,1); % Use only first band of color image
M = double((M>0)); % Threshold, so 0's are at noise locations
G = M .* F;
g = real( ifft2( ifftshift(G) ) );
figure, imshow(g, []);
return
I=imread('moon.tif');
imshow(I,[]);
I=double(I);
F=fft2(I);

return
I = imread('coins.png');
level = graythresh(I);
BW = im2bw(I,level);
imshow(BW)
return
f=imread('Fig0941(a)(wood_dowels).tif');
imshow(f),figure;
se=strel('disk',5);
fe=imerode(f,se);
imshow(fe);
fobr=imreconstruct(fe,f);
figure,
imshow(fobr);
return
f = @(x) (sum(x(:)) >= 0);
%f=@(x)(x(:));
lut = makelut(f,2)
return;
load mandrill;
imshow(X,map);
return
% Set number of iterations and wavelet name. 
iter = 200;
wav = 'haar';

% Compute approximations of the wavelet function using the
% cascade algorithm. 
for i = 1:iter 
    [phi,psi,xval] = wavefun(wav,i); 
    plot(xval,psi); 
    hold on 
end
title(['Approximations of the wavelet ',wav, ... 
       ' for 1 to ',num2str(iter),' iterations']); 
hold off
function colorImage()
x = (0:10)'; 
y = sin(x); 
xi = (0:.25:12)'; 
yi = interp1q([0 12 255]',[0 128 255]',[0:255]'); 
plot(x,y,'o',xi,yi)
return

I = imread('cameraman.tif');
[X, map] = gray2ind(I, 16);
imshow(X, map);
return
I2 = grayslice(I1,128); figure, imshow(I2,jet(128));
I3 = grayslice(I1,64); figure, imshow(I3,copper(64));
I4 = grayslice(I1,32); figure, imshow(I4,flag(32));
I5 = grayslice(I1,16); figure, imshow(I5,hot(16));
I6 = grayslice(I1,8); figure, imshow(I6,hsv(8));
I7 = grayslice(I1,4); figure, imshow(I7,pink(4));
I8 = grayslice(I1,2); figure, imshow(I8,gray(2));

function rgbcube(vx, vy, vz)

%RGBCUBE Displays an RGB cube on the MATLAB desktop.
%   RGBCUBE(VX, VY, VZ) displays an RGB color cube, viewed from point
%   (VX, VY, VZ).  With no input arguments, RGBCUBE uses (10, 10, 4)
%   as the default viewing coordinates.  To view individual color
%   planes, use the following viewing coordinates, where the first
%   color in the sequence is the closest to the viewing axis, and the 
%   other colors are as seen from that axis, proceeding to the right
%   right (or above), and then moving clockwise. 
%
%      -------------------------------------------------
%           COLOR PLANE                  ( vx,  vy,  vz)
%      -------------------------------------------------
%       Blue-Magenta-White-Cyan          (  0,   0,  10)
%       Red-Yellow-White-Magenta         ( 10,   0,   0)
%       Green-Cyan-White-Yellow          (  0,  10,   0)
%       Black-Red-Magenta-Blue           (  0, -10,   0)
%       Black-Blue-Cyan-Green            (-10,   0,   0)
%       Black-Red-Yellow-Green           (  0,   0, -10)
%

%   Copyright 2002-2004 R. C. Gonzalez, R. E. Woods, & S. L. Eddins
%   Digital Image Processing Using MATLAB, Prentice-Hall, 2004
%   $Revision: 1.5 $  $Date: 2003/10/13 00:52:14 $

% Set up parameters for function patch.
vertices_matrix = [0 0 0;0 0 1;0 1 0;0 1 1;1 0 0;1 0 1;1 1 0;1 1 1];
faces_matrix = [1 5 6 2;1 3 7 5;1 2 4 3;2 4 8 6;3 7 8 4;5 6 8 7];
colors = vertices_matrix; 
% The order of the cube vertices was selected to be the same as 
% the  order of the (R,G,B) colors (e.g., (0,0,0) corresponds to 
% black, (1,1,1) corresponds to white, and so on.)

% Generate RGB cube using function patch.
patch('Vertices', vertices_matrix, 'Faces', faces_matrix, ...
      'FaceVertexCData', colors, 'FaceColor', 'interp', ...
      'EdgeAlpha', 0) 

% Set up viewing point.
if nargin == 0
   vx = 10; vy = 10; vz = 4;
elseif nargin ~= 3
   error('Wrong number of inputs.')
end
axis off
view([vx, vy, vz])
axis square


function imageTransform()
load george
plot(x,y), axis ij, axis equal, axis([-1 1 -1 1]), grid on
return
f=checkerboard(50);
s=0.8;
theta=pi/18;
T=[s*cos(theta) s*sin(theta) 0
  -s*sin(theta) s*cos(theta) 0
   0 0 1];
tform=maketform('affine',T);
g=imtransform(f,tform);
imshow(g)

function fourier()

f=zeros(30,30);
f(5:24,13:17)=1;
F=fft2(f, 256,256);
F2=fftshift(F);       
figure,imshow(log(1+abs(F2)),[]) 
return

f   = imread('football.jpg');
f=f(:,:,3);
[M,N]=size(f);
F=fft2(f);
sig=10;
%H=lpfilter('gaussian',M,N,sig);
H=ones(M,N)*1/9;
G=H.*F;
g=real(ifft2(G));
imagesc(g);
return
imagesc(img),figure;
F= fft2(img);
F=ifft2(F);
imagesc(log(real(F)+1))
return
F= fftshift(F);
F=abs(F);
F = log(F+1);
F = mat2gray(F);
imagesc(F)
return
figure;

imagesc(100*log(1+abs(fftshift(F)))); colormap(gray); 
title('magnitude spectrum');

figure;
imagesc(angle(F));  colormap(gray);
title('phase spectrum');

function edgedetect
f=zeros(101,101);
f(1,1)=1;
H=hough(f);
imshow(H,[])
f(101,1)=1;
H=hough(f);
imshow(H,[])
f(1,101)=1;
H=hough(f);
imshow(H,[])
f(101,101)=1;
H=hough(f);
imshow(H,[])
f(51,51)=1;
x=hough(f);

imshow(x)
return
T=100;
f=zeros(128,128);
f(32:96,32:96)=255;

sigma=1;
[g3, t3]=edge(f, 'canny', [0.04 0.10], sigma);
figure,imshow(g3);
t3

[g1, t1]=edge(f, 'sobel', 'vertical');
imshow(g1);
figure, imshow(f);
t1
function basic2
tire=imread('tire.tif');
tire=tire(1:205,1:205);
temp=uint8(eye(size(tire)));
temp(logical(eye(size(tire))))=10;
scale=double(tire)*double(temp);
scale=uint8(scale);
imshow(scale)
return;
figure,imhist(tire);
title('Histogram of tire.tif--Predominately Low Intensity');
pout=imread('pout.tif');
figure,imhist(pout);
title('Histogram of pout.tif--Predominately Mid-range Intensity');
eight=imread('eight.tif');
figure, imhist(eight);
title('Histogram of eight.tif--Predominately High Intensity');
return

%Start with a truecolor image
img=imread('peppers.png');
%reduce to indexed color 
%using a custom colormap
map_custom=[
   1 1 1;  %white
   0 0 1;  %red
   0 0 0]; %black
img_custommap=dither(img, map_custom);
imshow(img_custommap, map_custom)

%reduce to indexed color 
%without dithering
[img_nodither, map2]=rgb2ind(img,8, 'nodither');
imshow(img_nodither, map2)
%reduce to indexed color
[img_indexed, map]=rgb2ind(img,10);
imshow(img_indexed, map)

%Convert to binary/Black and White
img_bin=im2bw(img); 
imshow(img_bin)
%Convert to binary/Black and White 
%with custom threshold (default is 0.5)
img_bin2=im2bw(img, 0.3);
imshow(img_bin2)
%Convert to grayscale
img_gray=rgb2gray(img);
imshow(img_gray)


function myfilter
I = imread('eight.tif');
J = imnoise(I,'salt & pepper',0.2);
K = medfilt2(J);
w=[1/9 1/9 1/9
   1/9 1/9 1/9
   1/9 1/9 1/9];
%w(w==1/9)=1/3

L=imfilter(I,w, 'conv');
imshow(J), figure, imshow(K),figure ,imshow(L)

return
q=imread ('cameraman.tif');
%f=imtool ('cameraman.tif');
w=[1/9 1/9 1/9
   1/9 1/9 1/9
   1/9 1/9 1/9];
%w(w==1/9)=1/3
q=ones(10,10);
res=imfilter(q,w);
imtool(res)
imtool(q)
return 
%MYFILTER Performs spatial correlation
%   I=MYFILTER(f, w) produces an image that has undergone correlation.
%   f is the original image
%   w is the filter (assumed to be 3x3)
%   The original image is padded with 0's
%Author: Nova Scheidt

% check that w is 3x3
[m,n]=size(w);
if m~=3 | n~=3
    error('Filter must be 3x3')
end

%get size of f
[x,y]=size(f);

%create padded f (called g)
%first, fill with zeros
g=zeros(x+2,y+2);
%then, store f within g
for i=1:x
    for j=1:y
        g(i+1,j+1)=f(i,j);
    end
end

%cycle through the array and apply the filter 
for i=1:x
    for j=1:y
        img(i,j)=g(i,j)*w(1,1)+g(i+1,j)*w(2,1)+g(i+2,j)*w(3,1) ... %first column
        + g(i,j+1)*w(1,2)+g(i+1,j+1)*w(2,2)+g(i+2,j+1)*w(3,2)... %second column
        + g(i,j+2)*w(1,3)+g(i+1,j+2)*w(2,3)+g(i+2,j+2)*w(3,3);
    end
end

%Convert to uint--otherwise there are double values and the expected
%range is [0, 1] when the image is displayed
img=uint8(img); 
figure, imshow(f)
figure, imshow(img)
function intense
I=imread('tire.tif');
imshow(I)
I2=im2double(I);
J=1*log(1+I2);
J2=2*log(1+I2);
J3=5*log(1+I2);
figure, imshow(J)
figure, imshow(J2)
figure, imshow(J3)
function imHistTest()
f = imread('pout.tif');
h = imhist(f);
h1 = h(1:10:256);
horz = 1:10:256;
bar(horz, h1);
axis([0 255 0 2000])
set(gca, 'xtick', 0:50:255)
set(gca, 'ytick', 0:200:15000)
set(gca, 'ytick', 0:500:1000)
xlabel('text string', 'fontsize', 9)
ylabel('text string', 'fontsize', 20)
title('Histogram of sds')

function imadjustTest
%RGB1 = imread('football.jpg');
%RGB2 = imadjust(RGB1,[0 0 0; 1 1 1],[]);
%imshow(RGB1), figure, imshow(RGB2)

I = imread('pout.tif');
J = imadjust(I);
M=1;N=5;
subplot(M,N,1); imshow(I)
subplot(M,N,2); imshow(J)

K = imadjust(I,[0 1],[1 0],1);
A=double(I(1:5,1:5))
B=double(K(1:5,1:5))
B+A
subplot(M,N,3);  imshow(K)
subplot(M,N,4);  imshow(imcomplement (I))
T = 1 ./ (1+ (125 ./(double(I) + eps)) .^ 20);
(T(1:5,1:5))
T=T*1;
subplot(M,N,5);  imshow(T)


function sinus
[rt,f,g]=twodsin(1,1/(4*pi),1/(4*pi),512,512);
i=mat2gray(g);
imshow(i),figure, imshow(g)


function basic
I = imread('peppers.png'); 
J = imread('pillsetc.png');
i=256;j=320;
 [p, pmax, pmin, pn] = improd(I(1:i,1:j),J(1:i,1:j));
figure, imshow(p)
figure, imshow(pn)
return;
 imshow(I(1:256,1:256).*J(1:256,1:256)*0.5)
K=imcomplement(J);
K=randi(500,500);
figure, imshow(K)
K=rand(500,500);
figure, imshow(K)
K = imlincomb(1,I(1:200,1:200),1,J(1:200,1:200));
figure, imshow(K,[])


I = imread('football.jpg');
size(I)
%J=mat2gray(I,[0,255]);
J=mat2gray(I);
size(J)
Q=I;
I(1:30:250,1:30:250,1)
J(1:30:250,1:30:250,1)  
M=1;N=3;
subplot(M,N,1); imshow(I)
subplot(M,N,2); imshow(J(:,:,2))
subplot(M,N,3); imshow(Q(:,:,2))

%K=I;
%K(1:806,1:506,2:3)=0;
%K=I(end:-1:1,:);
%size(K)
%K=I(1:2:256,1:2:320,3:-1:1);
%size(K)
%imshow(I),figure,imshow(K);
%plot(I(250,:,1))
%imfinfo('tissue.png')
%J = filter2(fspecial('sobel'),I);
%K = mat2gray(J);

%imshow(J),figure, imshow(K)


function [p, pmax, pmin, pn] = improd(f, g)
%IMPROD Compute the product of two images.
%   [P, PMAX, PMIN, PN] = IMPROD(F, G) outputs the element-by-element
%   product of two input images, F and G, the product maximum and
%   minimum values, and a normalized product array with values in the
%   range [0, 1]. The input images must be of the same size.  They
%   can be of class uint8, unit16, or double. The outputs are of
%   class double.
%
%   Sample M-file used in Chapter 2.

%   Copyright 2002-2004 R. C. Gonzalez, R. E. Woods, & S. L. Eddins
%   Digital Image Processing Using MATLAB, Prentice-Hall, 2004
%   $Revision: 1.1 $  $Date: 2003/02/22 17:00:54 $

fd = double(f);
gd = double(g);
p = fd.*gd;
pmax = max(p(:));
pmin = min(p(:));
pn = mat2gray(p); 

function [rt, f, g] = twodsin(A, u0, v0, M, N)
%TWODSIN Compare for-loops vs. vectorization.
%   The comparison is based on implementing the function f(x, y) =
%   Asin(u0x + v0y) for x = 0, 1, 2,..., M - 1 and y = 0, 1, 2,...,
%   N - 1. The inputs to the function are M and N and the constants
%   in the function. 
%
%   Sample M-file used in Chapter 2.

%   Copyright 2002-2004 R. C. Gonzalez, R. E. Woods, & S. L. Eddins
%   Digital Image Processing Using MATLAB, Prentice-Hall, 2004
%   $Revision: 1.3 $  $Date: 2003/10/13 00:53:47 $

% First implement using for loops.
 
tic   % Start timing.
f=zeros(M,N);
for r = 1:M
   u0x = u0*(r - 1);
   for c = 1:N
      v0y = v0*(c - 1);
      f(r, c) = A*sin(u0x + v0y);
   end
end

t1 = toc;   % End timing.

%	Now implement using vectorization.  Call the image g.

tic   % Start timing.

r = 0:M - 1;
c = 0:N - 1;
[C, R] = meshgrid(c, r);
g = A*sin(u0*R + v0*C);

t2 = toc;   % End timing.
 
%	Compute the ratio of the two times.

rt = t1/(t2 + eps); % Use eps in case t2 is close to 0