function main
clc, clear,imtool close all ,close all
params(1)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test1\exp1_001_b.bmp'};
params(2)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test1\exp1_001_c.bmp'};
%morpho()
%substract();%http://www.giassa.net/?page_id=635
subAvi();

function subAvi
cd('C:\Users\NobodyAir\Desktop\Temp');
Z = imread('mean.jpg');
Z=imresize(Z,0.5);
VR = mmreader('beltpotatoes_small.avi');
NumInFrames=get(VR,'NumberOfFrames');

%VW = VideoWriter('new.avi');
%open(VW);

figure;
for frame=500:NumInFrames
    I = read(VR,frame) - Z;
    imshow(I,[]);
    drawnow;
    %pause(0.1);
    %CDatas(:,:,:) = read(VR,frame) - Z;
    %writeVideo(VW,CDatas);   
end
%close(VW)

function substract

I = imread('rice.png');
tol=0;
figure
subplot(131);
imshow(I,[]);
title('Original');

background = imopen(I,strel('disk',15));

Ip = imsubtract(I,background);

subplot(132);
imshow(Ip,[])
title('imsubtract');

brighterThanBg = (I > background + tol);
darkerThanBg = (I < background - tol);
outIm = (brighterThanBg | darkerThanBg);

subplot(133);
imshow(outIm,[]);
title('fast');

function morpho
S = strel('square',5);
I = imread('blobs.png');

figure
subplot(131);
imshow(I,[]);
title('Raw');

A=imerode(I,S);

subplot(132);
imshow(A,[])
title('Erode');

A=imdilate(I,S);

subplot(133);
imshow(A,[])
title('Dilate');

