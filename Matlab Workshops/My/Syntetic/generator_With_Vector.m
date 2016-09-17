%%
%%SHIFT + (sin(2*pi * t)) * AMPLITUDE + 2 * (randn() * NOISE-(NOISE/2))

function main
clc,clear all,close all;
global PIX_COEF NOISE_COEF PARTICLES IMSIZE VEL DT FILENAME SUBPIXEL_W;
SUBPIXEL_W = 1;


FILENAME = 'velDump.txt';
if exist(FILENAME, 'file')==2
    fid = fopen(FILENAME,'w');
    fclose(fid);
    delete(FILENAME);
    delete('movie.mat');
end



%rows, cols
IMSIZE = [4*15*8 16*5*8];
PERCENT_PARTICLE = 0.01;
%Frame Time Interval
DT=1;
%BOXSIZE =[50 60];
%BOXCOEFF=IMSIZE./BOXSIZE;
%DEFAULT
AMPLITUDE = [1 0.5];
SHIFT = [2.1 .2];
%
NOISE_COEF = 0.05;

PIX_COEF = repmat(struct('Sx',SHIFT(1),'Sy',SHIFT(2),'Ax',AMPLITUDE(1),'Ay',AMPLITUDE(2),'Nx',AMPLITUDE(2),'Ny',AMPLITUDE(2)), IMSIZE(1), IMSIZE(2) );

VEL=repmat(struct('Vx',0,'Vy',0), IMSIZE(1), IMSIZE(2) );



%
% for r=1:IMSIZE(1)
%     for c=1:IMSIZE(2)
%         %noise of the sine function
%         NOISE = struct('X',AMPLITUDE(1) * NOISE_COEF,'Y', AMPLITUDE(2) * NOISE_COEF);
%         PIX_COEF(r,c).Nx = 2 * (randn() * NOISE.X-(NOISE.X/2)) ;% Generate Sine Wave
%         PIX_COEF(r,c).Ny = 2 * (randn() * NOISE.Y-(NOISE.Y/2)); % Generate Sine Wave
%
%     end
% end

MAXVEL = (max(SHIFT) +  2.5*max(AMPLITUDE))*1.41;

%%FARKLI KAYDIRMAK ICIN
%SU ANDA KULLANILMIYOR
if false
    for r=1:IMSIZE(1)
        for c=1:IMSIZE(2)
            if( r <IMSIZE(1)/2)
                PIX_COEF(r,c).Sx = 4.0;
            end
        end
    end
end


%PARTICLES = repmat(struct('Sx',0,'Sy',0),prod(IMSIZE) * PERCENT_PARTICLE);
%PARTICLES(:) = floor(rand(1,size(PARTICLES,2))*IMSIZE(1)) + 1;
%PARTICLES(:).Sy = floor(rand(1,size(PARTICLES,2))*IMSIZE(1)) + 1;

%%5 DIMENSIONS : X,Y,(R,G,B)
PARTICLES = ones(5,int32(prod(IMSIZE) * PERCENT_PARTICLE ));
%PARTICLE POSITION IS IN THE SUBPIXEL LEVEL
PARTICLES(1,:)= floor(rand(1,size(PARTICLES,2))*IMSIZE(1)) + 1;%*SUBPIXEL_W
PARTICLES(2,:)= floor(rand(1,size(PARTICLES,2))*IMSIZE(2)) + 1 ;%*SUBPIXEL_W
PARTICLES(3,:)= ones(1,size(PARTICLES,2));
PARTICLES(4,:)= rand(1,size(PARTICLES,2));
PARTICLES(5,:)= rand(1,size(PARTICLES,2));

%hist(-100*PARTICLES(1,:).*PARTICLES(2,:),1800)

%TIME CONTROL
for t=1:inf;
    tic
    
    
    %%VELOCITY GENERATION AND DISPLAY VECTORS
    for r=1:IMSIZE(1)
        for c=1:IMSIZE(2)
            COEF = PIX_COEF(r,c);
            %DELTA_COL = COEF.Sx + (sin(2*pi * t/20)) * COEF.Ax + COEF.Nx ;% Generate Sine Wave
            %DELTA_ROW = COEF.Sy + (sin(2*pi * t/20)) * COEF.Ay + COEF.Ny; % Generate Sine Wave
            
            DELTA_COL = COEF.Sx + (sin(2*pi * c/IMSIZE(2)*5) + sin(2*pi * r/IMSIZE(1)*3) ) * COEF.Ax ;% Generate Sine Wave
            DELTA_ROW = COEF.Sy + (sin(2*pi * c/IMSIZE(2)*3) + sin(2*pi * r/IMSIZE(1)*5) ) * COEF.Ay * randn(1) ; % Generate Sine Wave
            
            if(PARTICLES(1,1)==r && PARTICLES(2,1)==c)
                PARTICLES(:,1)
                [DELTA_ROW DELTA_COL]
            end
            
            if(abs(DELTA_COL)<.5 || abs(DELTA_ROW)<.5)
                addVal=0.5*sign(DELTA_COL);
                DELTA_COL=DELTA_COL+addVal;                                
            end
            
            VEL(r,c).Vx=DELTA_COL/DT ;
            %* BOXCOEFF(2);
            VEL(r,c).Vy=DELTA_ROW/DT ;                       
            %* BOXCOEFF(1);
        end
    end
    VELM=cell2mat(struct2cell(VEL(:,:,:)));
    WIDTH =9;
    CENTER=5;
   
    for i=1:WIDTH:size(VELM,2)-(WIDTH-1)
        for j=1:WIDTH:size(VELM,3)-(WIDTH-1)
            sub = VELM(:,i:i+WIDTH-1,j:j+WIDTH-1);            
            avgVEL(:,(i-1)/9+1,(j-1)/9+1) = mean(mean(sub,2),3);
        end
    end

    %MAXVEL = max(max(max(cell2mat(struct2cell(VEL(:,:))))))        
    

    %velSave(t);
    %cenVEL = cell2mat(struct2cell(VEL(5:9:end,5:9:end)));
    %cenVEL = cell2mat(struct2cell(VEL));
    cenVEL = cell2mat(struct2cell(VEL(CENTER:WIDTH:end,CENTER:WIDTH:end)));
    %figure(1)
    %imshow(IMG);
    if(t<10)
    %imwrite(rgb2gray(IMG),sprintf('CustomSyntetic/im%d.tif',t));
    end
    
    %% %PARTICLE CONTROL
    %IMAGE GENERATION
    IMG = zeros([IMSIZE 3]);
    for p=1:size(PARTICLES,2)
        moveSineByVEL(p,t);
        %moveSine(p,t);        
        %if(p<300)
        %    IMG(PARTICLES(1,p),PARTICLES(2,p),1)=PARTICLES(3,p);
        %    IMG(PARTICLES(1,p),PARTICLES(2,p),2)=PARTICLES(4,p);
        %    IMG(PARTICLES(1,p),PARTICLES(2,p),3)=PARTICLES(5,p);
        %else
        IMG(PARTICLES(1,p),PARTICLES(2,p),1)=PARTICLES(3,p);%/SUBPIXEL_W
        IMG(PARTICLES(1,p),PARTICLES(2,p),2)=PARTICLES(3,p);
        IMG(PARTICLES(1,p),PARTICLES(2,p),3)=PARTICLES(3,p);
        %end
    end
    figure(1)
    imagesc(IMG);
    drawnow;
    %impixelinfo
    %imwrite(rgb2gray(IMG),sprintf('CustomSyntetic/im%.3fp_%d.tif',PERCENT_PARTICLE,t));
    %continue;
    
   
    hFig=figure(2);
    clf
    %imshow(ones(IMSIZE))
    %truesize(hFig,IMSIZE*2)
    hold on
    %quiver(5:9:IMSIZE(2),5:9:IMSIZE(1),reshape(cenVEL(1,:,:),size(cenVEL,2),size(cenVEL,3)),reshape(cenVEL(2,:,:),size(cenVEL,2),size(cenVEL,3)),0.5)
    %quiverc(5:9:IMSIZE(2),5:9:IMSIZE(1),reshape(cenVEL(1,:,:),size(cenVEL,2),size(cenVEL,3)),reshape(cenVEL(2,:,:),size(cenVEL,2),size(cenVEL,3)))
    %ncquiverref(5:9:IMSIZE(2),5:9:IMSIZE(1),reshape(cenVEL(1,:,:),size(cenVEL,2),size(cenVEL,3)),reshape(cenVEL(2,:,:),size(cenVEL,2),size(cenVEL,3)),'m/s','max','true','col',[1:0.5:MAXVEL])
    %ncquiverref(1:IMSIZE(2),1:IMSIZE(1),reshape(cenVEL(1,:,:),size(cenVEL,2),size(cenVEL,3)),reshape(cenVEL(2,:,:),size(cenVEL,2),size(cenVEL,3)),'m/s','max','true','col',[1:0.5:MAXVEL])
    %ncquiverref(CENTER:WIDTH:IMSIZE(2),CENTER:WIDTH:IMSIZE(1),reshape(cenVEL(1,:,:),size(cenVEL,2),size(cenVEL,3)),reshape(cenVEL(2,:,:),size(cenVEL,2),size(cenVEL,3)),'m/s','max','true','col',[1:1:MAXVEL])    
    %REMOVE LAST COLUMN VEL
    ncquiverref(CENTER:WIDTH:IMSIZE(2)-(WIDTH-1),CENTER:WIDTH:IMSIZE(1)-(WIDTH-1),reshape(cenVEL(1,:,1:end-1),size(cenVEL,2),size(cenVEL,3)-1),reshape(cenVEL(2,:,1:end-1),size(cenVEL,2),size(cenVEL,3)-1),'m/s','max','true','col',[1:1:MAXVEL])    
    %figure(3);
    %clf
    %ncquiverref(CENTER:WIDTH:IMSIZE(2)-(WIDTH-1),CENTER:WIDTH:IMSIZE(1)-(WIDTH-1),reshape(avgVEL(1,:,:),size(avgVEL,2),size(avgVEL,3)),reshape(avgVEL(2,:,:),size(avgVEL,2),size(avgVEL,3)),'m/s','max','true','col',[1:1:MAXVEL])
    %ncquiverref(CENTER:WIDTH:IMSIZE(2),CENTER:WIDTH:IMSIZE(1),reshape(avgVEL(1,:,:),size(avgVEL,2),size(avgVEL,3)),reshape(avgVEL(2,:,:),size(avgVEL,2),size(avgVEL,3)),'m/s','max','true','col',[1:1:MAXVEL])
    
    %quiver(CENTER:WIDTH:IMSIZE(2),CENTER:WIDTH:IMSIZE(1),reshape(cenVEL(1,:,:),size(cenVEL,2),size(cenVEL,3)),reshape(cenVEL(2,:,:),size(cenVEL,2),size(cenVEL,3)))
    hold off
    %M(t) = getframe;
    toc
    t
end
%save('movie.mat','M');
%movie(M,1,1);

%DISPLACEMENT OF A PARTICLE IS BASED ON THE VELOCITY OF THE CURRENT
%POSITION(PIXEL)
function moveSineByVEL(pindx,t)
global PIX_COEF PARTICLES IMSIZE VEL DT SUBPIXEL_W;
%get the point's row,col
P=PARTICLES(:,pindx);
try
    DELTA_COL = (VEL(P(1),P(2)).Vx * DT )/SUBPIXEL_W;
    DELTA_ROW = (VEL(P(1),P(2)).Vy * DT )/SUBPIXEL_W;
catch(e)
e
end

if(pindx==1)
    [DELTA_ROW DELTA_COL]
end

PARTICLES(1,pindx) = P(1)+ round(DELTA_ROW);
PARTICLES(2,pindx) = P(2)+ round(DELTA_COL);
if(pindx==1)
    PARTICLES(:,pindx)
    cmda=abs(cell2mat(struct2cell(VEL(:,:))));
    sum(sum(round(cmda(2,:,:))))
end
%%MOVING RIGHT:ON X DIRECTION GET OFF FROM THE RIGHT END START FROM THE LEFT AT RANDOM Y
if(PARTICLES(1,pindx)> IMSIZE(1))
    PARTICLES(1,pindx)=PARTICLES(1,pindx)-IMSIZE(1);    
    PARTICLES(2,pindx)=floor(rand * IMSIZE(2) +1);
end
%%MOVING DOWN:ON Y DIRECTION GET OFF FROM THE BOTTOM END START FROM THE TOP AT RANDOM Y
if(PARTICLES(2,pindx)> IMSIZE(2))
    PARTICLES(2,pindx)=PARTICLES(2,pindx)-IMSIZE(2);
    PARTICLES(1,pindx)= floor(rand * IMSIZE(1) +1);
end

%%MOVING LEFT:ON X DIRECTION GET OFF FROM THE LEFT END START FROM THE RIGHT AT RANDOM Y
if(PARTICLES(1,pindx)< 1)
    PARTICLES(1,pindx)= IMSIZE(1);
    PARTICLES(2,pindx)= floor(rand * IMSIZE(2) +1);
end
%%MOVING UP:ON Y DIRECTION GET OFF FROM THE TOP END START FROM THE BOTTOM AT RANDOM Y
if(PARTICLES(2,pindx)< 1)
    PARTICLES(2,pindx)= IMSIZE(2);
    PARTICLES(1,pindx)= floor(rand * IMSIZE(1) +1);
end


%DISPLACEMENT OF A PARTICLE IS BASED ON THE VELOCITY OF THE CURRENT
%POSITION(PIXEL) RECALCULATED BELOW
%index of a point and the time
%SHIFT + (sin(2*pi * t)) * AMPLITUDE + rand
function moveSine(pindx,t)
global PIX_COEF PARTICLES IMSIZE;
%get the point's row,col
P=PARTICLES(:,pindx);
%get the sine coefficiants at x,y
COEF = PIX_COEF(P(1),P(2));

%DELTA_COL = COEF.Sx + (sin(2*pi * t)) * COEF.Ax + COEF.Nx ;% Generate Sine Wave
%DELTA_ROW = COEF.Sy + (sin(2*pi * t)) * COEF.Ay + COEF.Ny; % Generate Sine Wave
%DELTA_COL = COEF.Sx + (sin(2*pi * c/IMSIZE(2)*5) + sin(2*pi * r/IMSIZE(1)*3) ) * COEF.Ax ;% Generate Sine Wave
DELTA_COL = COEF.Sx + (sin(2*pi * P(2)/IMSIZE(2)*5) + sin(2*pi * P(1)/IMSIZE(1)*3) * rand()) * COEF.Ax  ;% Generate Sine Wave
DELTA_ROW = COEF.Sy + (sin(2*pi * P(2)/IMSIZE(2)*3) + sin(2*pi * P(1)/IMSIZE(1)*5) * rand()) * COEF.Ay; % Generate Sine Wave

if(pindx==1)
    [DELTA_ROW DELTA_COL]
end

%X2_data = SHIFT(1) + (sin(2*pi * t)) * AMPLITUDE(1) ;
PARTICLES(1,pindx) = P(1)+ round(DELTA_ROW);
PARTICLES(2,pindx) = P(2)+ round(DELTA_COL);
if(PARTICLES(1,pindx)> IMSIZE(1))
    PARTICLES(1,pindx)=PARTICLES(1,pindx)-IMSIZE(1);    
    PARTICLES(2,pindx)=round(rand * IMSIZE(2) +1);
end

if(PARTICLES(2,pindx)> IMSIZE(2))
    PARTICLES(2,pindx)=PARTICLES(2,pindx)-IMSIZE(2);
    PARTICLES(1,pindx)= round(rand * IMSIZE(1) +1);
end

if(PARTICLES(1,pindx)< 1)
    PARTICLES(1,pindx)= IMSIZE(1);
    PARTICLES(2,pindx)= round(rand * IMSIZE(2) +1);
end

if(PARTICLES(2,pindx)< 1)
    PARTICLES(2,pindx)= IMSIZE(2);
    PARTICLES(1,pindx)= round(rand * IMSIZE(1) +1);
end

function velSave(t)
global VEL IMSIZE DT FILENAME;
fid = fopen(FILENAME,'a');
fprintf(fid,'ROW\tCOL\tFrameSeq#\tFrameCaptureTime\tFrameInterval(ms)\t%d\t%d\t%d\t%f\t%f\n',IMSIZE(1),IMSIZE(2),t,t*DT,DT);
for i=1:size(VEL,1)
    for j=1:size(VEL,2)
        fprintf(fid,'%.3f,%.3f\t',VEL(i,j).Vx, VEL(i,j).Vy);
    end
    fprintf(fid,'\n');
end
fclose(fid);