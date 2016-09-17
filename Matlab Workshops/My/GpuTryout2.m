clc,clear all,close all;
%gpu = gpuDevice;
%reset(gpuDevice); 
%wait(gpu);
%g = gpuDevice; 
%free=g.FreeMemory

NfftHeight=64;
    NfftWidth=64;
    size=32;
tic;
for i=1:2 
    %%%---
    a2=rand(size,size);
    b2=rand(size,size);    

    a2 = a2 - mean2(a2);
    b2 = b2 - mean2(b2);

    a2=gpuArray(a2);
    b2=gpuArray(b2);

        
    b2 = b2(end:-1:1,end:-1:1);
    
    ffta=fft2(single(a2),NfftHeight,NfftWidth);
    fftb=fft2(single(b2),NfftHeight,NfftWidth);
   
    c = real(ifft2(ffta.*fftb));
       
    c(c<0) = 0;
    c = gather(c);
end
time2 = toc