clc, clear all,close all
readVideo=1;
if(readVideo==1)
    skipFrame=500;
    take=1000;
    %vRdr = VideoReader('ininwater.mp4');
    vRdr = VideoReader('D:\Matlab Workshops\112m410\Density\MAH00621.MP4');    
    %get(vRdr)
    %img1=double(rgb2gray(read(vRdr,1)));
    nFrames = vRdr.NumberOfFrames-skipFrame;
    vidHeight = vRdr.Height;
    vidWidth = vRdr.Width;
    mov(1:100) = ...
    struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),...
           'colormap',[]);
    for k = skipFrame : skipFrame+take%%nFrames
        frm=read(vRdr,k);
        crm=imcrop(frm,[10 10 500 500]);
        mov(k-skipFrame+1).cdata = crm;
        %mov(k-skipFrame+1).cdata = read(vRdr,k);
        
    end    
else
    x = imread(sprintf('ripple%d.tif',1));   
    struct('cdata',zeros([size(x),3],'uint8'),...
           'colormap',[]);
    nFrames=5;
end

while true
    for imagInd=1:nFrames
        N=16;
        xInv=rgb2gray( mov(imagInd).cdata);
        x = 255-xInv;        
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
        
        IADisp=IADisp/(255*16*16);
        
        %DRAW
        image(xInv)
        colormap(gray(256));
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
        remained=numel(xlbl)-numel(IADisp(:));
        IATitles=[IADisp(:);ones(remained,1)];
        lbl = strtrim(cellstr(num2str((IATitles),'%.2f')));
        text(xlbl(:), ylbl(:), lbl(:),'color','w','HorizontalAlignment','center','VerticalAlignment','middle','FontSize',5);
        drawnow
        %pause()
    end
end