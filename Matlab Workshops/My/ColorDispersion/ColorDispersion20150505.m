function ColorDispersion2
clear all,close all
%file='C:/Users/NobodyLen/Desktop/Google Drive/Tubitak112M410/Videos etc/20150729/2015-07-29/MAH00650.MP4';%'C:/Users/Ufuk/Desktop/Google Drive/Tubitak112M410/Videos etc/2015-05-14_DeneyTop4K5CameraSettings/MAH00641.MP4';%'C:/Users/Ufuk/Desktop/Google Drive/Tubitak112M410/Videos etc/2015-04-30/MAH00640.MP4';
file='C:/Users/NobodyLen/Desktop/Google Drive/Tubitak112M410/Videos etc/20150806/2015-08-06/MAH00657.MP4';
skipFrame=350;
take=2000;
vRdr = VideoReader(file);
%nFrames = vRdr.NumberOfFrames-skipFrame;
vidHeight = vRdr.Height;
vidWidth = vRdr.Width;
%DensityValuesForCol1AllFrames=zeros(vidHeight,vidWidth,250);
BGDensity=findBGDensity(vRdr,skipFrame-200,200);
for k = skipFrame : skipFrame+take    
    crI=read(vRdr,k);
    display([num2str(k), '']);
    
    %TEST FOR HISTOGRAM ON LIMITED AREA
    %croped=imcrop(crI,[349.5 313.5 46 44]);    
    %figure(1),
    %subplot(1,2,1)
    %imshow(croped,[])
    %subplot(1,2,2)
    %hist(double(croped(:)),0:1:255);axis([0 255 0 1500])
    %
    IADens=findDensity(crI);             
    %DensityValuesForAllFrames(:,:,k-skipFrame)=
    DensityForFrame=showDensity(BGDensity,IADens,crI);
    %figure(1),imagesc(DensityForFrame(:,1));
    %DensityValuesForCol1AllFrames(:,:,mod(k-skipFrame-1,250)+1)=DensityForFrame;
    %if(mod(k-skipFrame,250)==0)
    %    save(sprintf('%d.mat',k-skipFrame),'DensityValuesForCol1AllFrames','-v7.3');
    %end
    title(num2str(k));
end
%save(sprintf('%d.mat',k-skipFrame),'DensityValuesForCol1AllFrames');
display('');

function BGDensity=findBGDensity(vRdr,skipFrame,take)
SumOfFrames=zeros( vRdr.Height,vRdr.Width,3);
for k = skipFrame : skipFrame+take-1
    crI=read(vRdr,k);
    SumOfFrames=SumOfFrames+double(crI);
end
%%
BGDensity=uint8(SumOfFrames/take);
figure(3),subplot(1,2,1),imshow(BGDensity);
%%
%x=rgb2gray(uint8(SumOfFrames/take));
%figure,imshow(x,[])
%BGDensity=double(x)/255;

function IADisp=findDensity(img)
%%
IADisp=img ;
figure(3),subplot(1,2,1),imshow(img);
%%
%x=rgb2gray(img);
%figure(3),subplot(1,2,1),imshow(img,[])
%IADisp=double(x)/255;


function Density=showDensity(dens1,dens2,x)
%delta=0.025*5;
%delta=0.025*10*255;
delta=10;

dens1=double(dens1);
dens2=double(dens2);

%res=uint8(double(dens2).*(abs(dens1-dens2)>delta));
Density=abs(dens1-dens2).*(abs(dens1-dens2)>delta);
Density=uint8(Density(:,:,1));
%Density=rgb2gray(Density);
figure(3),subplot(1,2,2);imshow(Density);
colormap jet;
impixelinfo
colorbar


