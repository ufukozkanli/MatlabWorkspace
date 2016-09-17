clc,clear all,close all
d=0.01;
I=zeros(369,551);
IN=imnoise(I,'salt & pepper',d);
figure,imshow(IN);

IT=[imnoise(zeros(8,551),'salt & pepper',d);IN];
IT(370:369+8,:)=[];
figure,imshow(IT);

%%%White/Black
white=size(find(IN(:)==1));
black=size(find(IN(:)==0));
bwRatio=black/white;
bwRatio

imwrite(IN,'..\..\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test1\test2.bmp','bmp');
imwrite(IT,'..\..\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test1\test1.bmp','bmp');

%imwrite(IT,'test.bmp','bmp');