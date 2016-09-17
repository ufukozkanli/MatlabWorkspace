function main
clc,clear all,close all;
global wAng;
global hAng;
wAng=40;
hAng=27;
f1();
%%
% 1920 x 1080 (29.97, 25, 23.976 fps)
% 1280 x 720 (59.94, 50 fps)
% 640 x 480 (59.94, 50 fps)
%%
function f1()
global wAng;
global hAng;

fprintf('W - H \tCam Min Dist\t 640x480     \t              \t1280x720     \t              \t1920 x 1080    \t==>         \t IA 8x8 pixel \t            \t IA 16x16 pixel \t            \t IA 32x32 pixel \t               \n');
fprintf('cm    \tcm          \tPixelCnt/cm² \tPixelArea(µm²)\tPixelCnt/cm² \tPixelArea(µm²)\tPixelCnt/cm² \tPixelArea(µm²)\t Width (cm)        \tMax V(cm/s) \t Width (cm)          \tMax V(cm/s) \t Width (cm)          \tMax V(cm/s) \t \n');


for i=120:-10:40    
    w=i;
    h=i/2;
    
    hBest=w*(tan(((hAng/2)/180)*pi)/tan(((wAng/2)/180)*pi));
    
    f2(w,h);
    f2(w,hBest);
end

function f2(w,h)
global wAng;
global hAng;

dW=(w/2)/tan(((wAng/2)/180)*pi);
dH=(h/2)/tan(((hAng/2)/180)*pi);

funCalc=@(wRes,hRes)((wRes*hRes)/(w*h));


fprintf('% 3.1f  - % 3.1f  \t  %3.1f         \t % 3.1f  \t % 3.1f   \t % 3.1f  \t % 3.1f   \t % 3.1f  \t % 3.1f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t % 3.2f \t \n',w,h,max([dW,dH]),funCalc(640,480),1/funCalc(640,480)*1e8,funCalc(1280,720),1/funCalc(1280,720)*1e8,funCalc(1920,1080),1/funCalc(1920,1080)*1e8,sqrt(1/funCalc(1920,1080)*64),sqrt(1/funCalc(1920,1080)*64)*20      ,sqrt(1/funCalc(1920,1080)*256),sqrt(1/funCalc(1920,1080)*256)*20,     sqrt(1/funCalc(1920,1080)*1024),sqrt(1/funCalc(1920,1080)*1024)*20);

