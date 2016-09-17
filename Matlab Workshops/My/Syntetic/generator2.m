%%
%%SHIFT + (sin(2*pi * t)) * AMPLITUDE + 2 * (randn() * NOISE-(NOISE/2))

function main
clc,clear all,close all;
global PIX_COEF NOISE_COEF PARTICLES IMSIZE VEL DT FILENAME;

FILENAME = 'velDump.txt';
if exist(FILENAME, 'file')==2
  fid = fopen(FILENAME,'w');
  fclose(fid);
  delete(FILENAME);
  delete('movie.mat');
end



%rows, cols
IMSIZE = [16*15*2 16*20*2];
PERCENT_PARTICLE = 0.1;
%Frame Time Interval
DT=0.5;
%BOXSIZE =[50 60];
%BOXCOEFF=IMSIZE./BOXSIZE;
%DEFAULT
AMPLITUDE = [2 2];
SHIFT = [4 0];
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

MAXVEL = (max(SHIFT) +  3*max(AMPLITUDE))*1.41;

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


PARTICLES = ones(5,int32(prod(IMSIZE) * PERCENT_PARTICLE ));
PARTICLES(1,:)= floor(rand(1,size(PARTICLES,2))*IMSIZE(1)) + 1;
PARTICLES(2,:)= floor(rand(1,size(PARTICLES,2))*IMSIZE(2)) + 1 ;
PARTICLES(3,:)= ones(1,size(PARTICLES,2));
PARTICLES(4,:)= rand(1,size(PARTICLES,2));
PARTICLES(5,:)= rand(1,size(PARTICLES,2));

%hist(-100*PARTICLES(1,:).*PARTICLES(2,:),1800)

%TIME CONTROL
for t=1:60;
    tic
    %PARTICLE CONTROL
    %%
    %IMAGE GENERATION    
    IMG = zeros([IMSIZE 3]);
    for p=1:size(PARTICLES,2)
        PARTICLES(:,p);
        
        moveSine(p,t);
        IMG(PARTICLES(1,p),PARTICLES(2,p))=0;
        %if(p<300)
        %    IMG(PARTICLES(1,p),PARTICLES(2,p),1)=PARTICLES(3,p);
        %    IMG(PARTICLES(1,p),PARTICLES(2,p),2)=PARTICLES(4,p);
        %    IMG(PARTICLES(1,p),PARTICLES(2,p),3)=PARTICLES(5,p);
        %else
        IMG(PARTICLES(1,p),PARTICLES(2,p),1)=PARTICLES(3,p);
        IMG(PARTICLES(1,p),PARTICLES(2,p),2)=PARTICLES(3,p);
        IMG(PARTICLES(1,p),PARTICLES(2,p),3)=PARTICLES(3,p);
        
        %end
        
        PARTICLES(:,p);
    end
    figure(1)
    imagesc(IMG);
    drawnow;  
    imwrite(rgb2gray(IMG),sprintf('CustomSyntetic/im%d_%fp.tif',t,PERCENT_PARTICLE));   
    %continue;
    %%
    for r=1:IMSIZE(1)
        for c=1:IMSIZE(2)
            COEF = PIX_COEF(r,c);
            %DELTA_COL = COEF.Sx + (sin(2*pi * t/20)) * COEF.Ax + COEF.Nx ;% Generate Sine Wave
            %DELTA_ROW = COEF.Sy + (sin(2*pi * t/20)) * COEF.Ay + COEF.Ny; % Generate Sine Wave
            
            DELTA_COL = COEF.Sx + (sin(2*pi * c/IMSIZE(2)*5) + sin(2*pi * r/IMSIZE(1)*3) + rand()) * COEF.Ax  ;% Generate Sine Wave
            DELTA_ROW = COEF.Sy + (sin(2*pi * c/IMSIZE(2)*3) + sin(2*pi * r/IMSIZE(1)*5) + rand()) * COEF.Ay ; % Generate Sine Wave
            
            VEL(r,c).Vx=DELTA_COL/DT ;
            %* BOXCOEFF(2);
            VEL(r,c).Vy=DELTA_ROW/DT ;
            %* BOXCOEFF(1);
        end
    end
    %velSave(t);    
    %avgVEL = cell2mat(struct2cell(VEL(5:9:end,5:9:end)));
    %avgVEL = cell2mat(struct2cell(VEL));
    avgVEL = cell2mat(struct2cell(VEL(8:16:end,8:16:end)));
    %figure(1)
    %imshow(IMG);
    %imwrite(rgb2gray(IMG),sprintf('CustomSyntetic/im%d.tif',t));
    
    hFig=figure(2);
    clf    
    %imshow(ones(IMSIZE))
    %truesize(hFig,IMSIZE*2)
    hold on
    %quiver(5:9:IMSIZE(2),5:9:IMSIZE(1),reshape(avgVEL(1,:,:),size(avgVEL,2),size(avgVEL,3)),reshape(avgVEL(2,:,:),size(avgVEL,2),size(avgVEL,3)),0.5)     
    %quiverc(5:9:IMSIZE(2),5:9:IMSIZE(1),reshape(avgVEL(1,:,:),size(avgVEL,2),size(avgVEL,3)),reshape(avgVEL(2,:,:),size(avgVEL,2),size(avgVEL,3)))     
    %ncquiverref(5:9:IMSIZE(2),5:9:IMSIZE(1),reshape(avgVEL(1,:,:),size(avgVEL,2),size(avgVEL,3)),reshape(avgVEL(2,:,:),size(avgVEL,2),size(avgVEL,3)),'m/s','max','true','col',[1:0.5:MAXVEL])     
    %ncquiverref(1:IMSIZE(2),1:IMSIZE(1),reshape(avgVEL(1,:,:),size(avgVEL,2),size(avgVEL,3)),reshape(avgVEL(2,:,:),size(avgVEL,2),size(avgVEL,3)),'m/s','max','true','col',[1:0.5:MAXVEL])     
    ncquiverref(8:16:IMSIZE(2),8:16:IMSIZE(1),reshape(avgVEL(1,:,:),size(avgVEL,2),size(avgVEL,3)),reshape(avgVEL(2,:,:),size(avgVEL,2),size(avgVEL,3)),'m/s','max','true','col',[1:0.5:MAXVEL])     
    hold off
    M(t) = getframe;
    toc
    t
end
%save('movie.mat','M');
%movie(M,1,1);

%index of a point and the time
function moveSine(pi,t)
global PIX_COEF PARTICLES IMSIZE;
%get the point's row,col
P=PARTICLES(:,pi);
%get the sine coefficiants at x,y
COEF = PIX_COEF(P(1),P(2));

%DELTA_COL = COEF.Sx + (sin(2*pi * t)) * COEF.Ax + COEF.Nx ;% Generate Sine Wave
%DELTA_ROW = COEF.Sy + (sin(2*pi * t)) * COEF.Ay + COEF.Ny; % Generate Sine Wave

DELTA_COL = COEF.Sx + (sin(2*pi * P(2)/IMSIZE(2)*5) + sin(2*pi * P(1)/IMSIZE(1)*3) ) * COEF.Ax  ;% Generate Sine Wave
DELTA_ROW = COEF.Sy + (sin(2*pi * P(2)/IMSIZE(2)*3) + sin(2*pi * P(1)/IMSIZE(1)*5) ) * COEF.Ay; % Generate Sine Wave
            


%X2_data = SHIFT(1) + (sin(2*pi * t)) * AMPLITUDE(1) ;
PARTICLES(1,pi) = P(1)+ round(DELTA_ROW);
PARTICLES(2,pi) = P(2)+ round(DELTA_COL);
if(PARTICLES(1,pi)> IMSIZE(1))
    PARTICLES(1,pi)=PARTICLES(1,pi)-IMSIZE(1);
end

if(PARTICLES(2,pi)> IMSIZE(2))
    PARTICLES(2,pi)=PARTICLES(2,pi)-IMSIZE(2);
end

if(PARTICLES(1,pi)< 1)
    PARTICLES(1,pi)= IMSIZE(1);
end

if(PARTICLES(2,pi)< 1)
    PARTICLES(2,pi)= 1;
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