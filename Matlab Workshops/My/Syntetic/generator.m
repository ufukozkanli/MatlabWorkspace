%%
%%SHIFT + (sin(2*pi * t)) * AMPLITUDE + 2 * (randn() * NOISE-(NOISE/2))

function main
clc,clear all,close all;
global PIX_COEF NOISE_COEF PARTICLES IMSIZE;


%rows, cols
IMSIZE = [16*30 16*40];
PERCENT_PARTICLE = 0.2;

%DEFAULT
AMPLITUDE = [0.5 0];
SHIFT = [4 0];
%
NOISE_COEF = 0.00;

PIX_COEF = repmat(struct('Sx',SHIFT(1),'Sy',SHIFT(2),'Ax',AMPLITUDE(1),'Ay',AMPLITUDE(2)), IMSIZE(1), IMSIZE(2) );
%%FARKLI KAYDIRMAK ICIN
%SU ANDA KULLANILMIYOR
if -1
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


PARTICLES = ones(2,prod(IMSIZE) * PERCENT_PARTICLE );
PARTICLES(1,:)= floor(rand(1,size(PARTICLES,2))*IMSIZE(1)) + 1;
PARTICLES(2,:)= floor(rand(1,size(PARTICLES,2))*IMSIZE(2)) + 1 ;
PARTICLES(3,:)= rand(1,size(PARTICLES,2));
PARTICLES(4,:)= rand(1,size(PARTICLES,2));
PARTICLES(5,:)= rand(1,size(PARTICLES,2));

%hist(-100*PARTICLES(1,:).*PARTICLES(2,:),1800)

%TIME CONTROL
for t=1:200;
    tic
    %PARTICLE CONTROL
    TEMPPARTICLES=PARTICLES;
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
    imshow(IMG);    
    imwrite(rgb2gray(IMG),sprintf('CustomSyntetic/im_%f_%d.tif',PERCENT_PARTICLE,t));
    
    ParDispROW =  PARTICLES(1,:) - TEMPPARTICLES(1,:);
    ParDispCOL =  PARTICLES(2,:) - TEMPPARTICLES(2,:);
    
    
    drawnow
    toc
end

%index of a point and the time
function moveSine(pi,t)
global PIX_COEF NOISE_COEF PARTICLES IMSIZE;
%get the point's row,col
P=PARTICLES(:,pi);
%get the sine coefficiants at x,y
COEF = PIX_COEF(P(1),P(2));
%noise of the sine function
NOISE = struct('X',COEF.Ax * NOISE_COEF,'Y',COEF.Ay * NOISE_COEF);

DELTA_COL = COEF.Sx + (sin(2*pi * t)) * COEF.Ax + 2 * (randn(size(t)) * NOISE.X-(NOISE.X/2)) ;% Generate Sine Wave
DELTA_ROW = COEF.Sy + (sin(2*pi * t)) * COEF.Ay + 2 * (randn(size(t)) * NOISE.Y-(NOISE.Y/2)); % Generate Sine Wave
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