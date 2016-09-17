function PIV
clc, clear,imtool close all ,close all

[folder, name, ext] = fileparts(mfilename('fullpath'));
%addpath(fullfile(folder, '/Test Pics'))
cd(fullfile(folder, '../PIV TEST/Test Pics'))

params(1)={'\exp1_001_b.bmp'};
params(2)={'\exp1_001_c.bmp'};
params(3)={'\PTVlab_gen_01.tif'};
params(4)={'\PTVlab_gen_02.tif'};
params(5)={'\PTVlab_gen2_01.tif'};
params(6)={'\PTVlab_gen2_02.tif'};
params(7)={'\PTVlab_gen3_01.tif'};
params(8)={'\PTVlab_gen3_02.tif'};
params(9)={'\PTVlab_gen4_01.tif'};
params(10)={'\PTVlab_gen4_02.tif'};

params(11)={'\00020359.bmp'};
params(12)={'\00020360.bmp'};
params(13)={'\00020361.bmp'};
params(14)={'\00020362.bmp'};

params(15)={'\Ripple1.tif'};
params(16)={'\Ripple2.tif'};

params(17) = {'\RandomLinear\RandomLinear1.bmp'};
params(18) = {'\RandomLinear\RandomLinear2.bmp'};

params(19) = {'CustomSyntetic\im1_003p.tif'};
params(20) = {'CustomSyntetic\im2_003p.tif'};

%backgroundsubstractionExample(params)
backgroundsubstraction(params);
function backgroundsubstractionExample(params)
xyloObj = VideoReader('traffic.avi');
k = xyloObj.NumberOfFrames;
img1=rgb2gray(read(xyloObj,120));
%imgSum=double(rgb2gray(read(xyloObj,0)));
for i=2:k
    img2=rgb2gray(read(xyloObj,i));    
    %MEAN FILTER
    %imgSum=imgSum+double(img2);
    
    imshow((abs(img1-img2)),[],'InitialMagnification', 550)
    pause(0.1)
end
%imshow(uint8(imgSum/k))

function backgroundsubstraction(params)
%METHOD 
%1:MEAN   %SUM OF ALL FRAMES
%2:EPSILON ALFA  %IMG DIFF
method=1;
readVideo=1;
if(method==2)
    epsilon=10;
    alfa=0.2;
end
if(readVideo==1)
    xyloObj = VideoReader('traffic.avi');%traffic.avi no particule no lift no cuda.m4v
    k = xyloObj.NumberOfFrames;
    img1=double(rgb2gray(read(xyloObj,1)));
    if(k>120)
        k=120;
    end
else
    k=4;
    img1=double(imread(cell2mat(params(11+(k/2)))));
end
imgT=img1;
figure
subplot(1,2,1)
imshow(imgT,[]);
[h, w]=size(img1);
BA=(zeros(h,w));
for i=2:k
    if(readVideo==1)
        imgI = double(rgb2gray(read(xyloObj,i)));
    else
        imgI = double(imread(cell2mat(params(10+i))));
    end
    imgDif = abs(imgT-imgI);    
    if(method==1)      
       BA=BA+imgI;
    elseif(method==2)       
       BA(imgDif>=epsilon)=BA(imgDif>=epsilon)+1;
       %sum(sum(BA))
    end
    %imgT=img2;
end
mean(mean(BA)), max(max(BA))
subplot(1,2,2)
if(method==1)
    BA=BA/(k-1);
    %BA(BA<100)=0;
    imshow(BA,[]);
elseif(method==2)
    BA(BA<=(alfa*k))=0;
    imgT=img1;
    imgT(BA~=0)=0;    
    imshow(imgT,[]);
end
