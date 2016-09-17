function ColorDispersion2
clc, clear all,close all
readVideo=1;
if(readVideo==1)
    skipFrame=500;
    take=1000;
    %vRdr = VideoReader('ininwater.mp4');
    vRdr = VideoReader('C:/Users/Ufuk/Desktop/Google Drive/Tubitak112M410/Videos etc/2015-04-30/MAH00640.MP4');
    %get(vRdr)
    %img1=double(rgb2gray(read(vRdr,1)));
    nFrames = vRdr.NumberOfFrames-skipFrame;
    vidHeight = vRdr.Height;
    vidWidth = vRdr.Width;
    for k = skipFrame : skipFrame+take
        %crm=imcrop(read(vRdr,k),[10 10 500 500]);
        crm=read(vRdr,k);
        if(k==skipFrame)
            bckg=crm;
            first=true;
            IADispF=showDensity(crm,crm,0,k);
            continue;
        end
        IADisp=showDensity(crm,bckg,IADispF,k);
    end
else
    x = imread(sprintf('ripple%d.tif',1));
    struct('cdata',zeros([size(x),3],'uint8'),...
        'colormap',[]);
    nFrames=5;
end


function IADisp=showDensity(img,bckg,dens,first)
delta=0.05;
%while true
%    for imagInd=1:nFrames
N=16;
%img(abs(double(img)-double(bckg)))<ones(size(img)))
if(first)
    xInv=rgb2gray(img);    
    x = 255-xInv;
else
    %temp=uint8(abs(double(img)-double(bckg)));
    %figure(1),subplot(1,3,1),imshow(temp,[]);subplot(1,3,2),imshow(img,[])
    %drawnow;
    %xInv=rgb2gray(temp);
    %figure(1),subplot(1,3,3),imshow(img(:,:,3),[]);
    x = 255-xInv;
end
sz=size(x);
IAC=floor(sz./N);
IADisp=zeros(IAC(1),IAC(2));
for i=1:IAC(1)
    for j=1:IAC(2)
        ia = x((i-1)*N+1:i*N , (j-1)*N+1:j*N);
        IADisp(i,j)=sum(sum(ia));
    end
end
%NORMALIZE
%         mn = min(min(IADisp));
%         mx = max(max(IADisp));
%         IADisp= (IADisp-mn)/(mx-mn)*10;
%Average and normalization
IADisp=IADisp/(255*N*N);
if(k)
    return
end
res=IADisp.*(abs(IADisp-dens)>delta);

%DRAW
figure(2)
image(xInv)
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
lbl = strtrim(cellstr(num2str((IATitles),'%.2f')));
text(xlbl(:), ylbl(:), lbl(:),'color','w','HorizontalAlignment','center','VerticalAlignment','middle','FontSize',5);
drawnow
%pause()
%    end
%end