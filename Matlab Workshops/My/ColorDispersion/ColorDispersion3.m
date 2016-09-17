function ColorDispersion2
clc, clear all,close all
global N;
N=2;
readVideo=1;
if(readVideo==1)
    skipFrame=150;
    take=2000;
    %vRdr = VideoReader('ininwater.mp4');
    vRdr = VideoReader('C:/Users/Ufuk/Desktop/Google Drive/Tubitak112M410/Videos etc/2015-04-30/MAH00640.MP4');
    %'C:/Users/Ufuk/Desktop/Google Drive/Tubitak112M410/Videos etc/Density/MAH00621.MP4');    
    %nFrames = vRdr.NumberOfFrames-skipFrame;
    %vidHeight = vRdr.Height;
    %vidWidth = vRdr.Width;
    for k = skipFrame : skipFrame+take
        %crI=imcrop(read(vRdr,k),[10 10 500 500]);
        crI=read(vRdr,k);                
        if(k==skipFrame)
            fI=crI;
            IADensF=findDensity(crI);
            continue;
        end
        IADens=findDensity(crI);
        showDensity(IADensF,IADens,crI);%uint8(abs(double(crI)-double(fI)))
    end
else
    x = imread(sprintf('ripple%d.tif',1));
    struct('cdata',zeros([size(x),3],'uint8'),...
        'colormap',[]);
    nFrames=5;
end


function IADisp=findDensity(img)
global N;
x=rgb2gray(img);
imgTmp=img;
imgTmp(:,:,1)=0;imgTmp(:,:,2)=0;
imgTmp(:,:,3)=x;

figure(3),subplot(1,2,1),imshow(img,[])

x=255-imgTmp(:,:,3);
sz=size(x);
IAC=floor(sz./N);
IADisp=zeros(IAC(1),IAC(2));
for i=1:IAC(1)
    for j=1:IAC(2)
        ia = x((i-1)*N+1:i*N , (j-1)*N+1:j*N);
        IADisp(i,j)=sum(sum(ia));
    end
end

%Average and normalization
IADisp=IADisp/(255*N*N);

function showDensity(dens1,dens2,x)
global N;
delta=0.025*5;
res=dens2.*(abs(dens1-dens2)>delta);
%Set P?xel value for 
for i=1:size(res,1)
    for j=1:size(res,2)
        x((i-1)*N+1:i*N , (j-1)*N+1:j*N,1)=0;
        x((i-1)*N+1:i*N , (j-1)*N+1:j*N,2)=0;
        x((i-1)*N+1:i*N , (j-1)*N+1:j*N,3)=uint8(res(i,j)*255);
    end
end

%DRAW
figure(3)
subplot(1,2,2);
image(x)
return;
%colormap(gray(256));
%axis image
grid on
%X-Y Range
set(gca,'YTick',0:N:size(x,1))
set(gca,'XTick',0:N:size(x,2))
%# grid domains
xg = 0:N:size(x,2)-N+1;
yg = 0:N:size(x,1)-N+1;
%# label coordinates
[xlbl, ylbl] = meshgrid(xg+N/2, yg+N/2);
%# create cell arrays of number labels
remained=numel(xlbl)-numel(res(:));
IATitles=[res(:);ones(remained,1)];
str=num2str((IATitles),'%.2f');
str(strmatch('0.00',str),:)=' ';
lbl = strtrim(cellstr(str));
%text(xlbl(:), ylbl(:), lbl(:),'color','w','HorizontalAlignment','center','VerticalAlignment','middle','FontSize',5);
drawnow
%pause()
%    end
%end
