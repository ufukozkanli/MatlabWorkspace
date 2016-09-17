clc,clear all,close all;
load('C:\Users\zirve\Documents\Visual Studio 2010\Projects\T1001\TestBook1\tmp\image1.txt');
load('C:\Users\zirve\Documents\Visual Studio 2010\Projects\T1001\TestBook1\tmp\image2.txt');
load('C:\Users\zirve\Documents\Visual Studio 2010\Projects\T1001\TestBook1\tmp\sumIA0.txt');

sum=0;
r=0;
for i=1:32
    for j=1:32
        sum= sum+ image1(r+j,3)* image2(r+j,3);
    end
    r=r+270;
end
sum