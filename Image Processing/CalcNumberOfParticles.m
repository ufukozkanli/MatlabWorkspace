%function main
clear all, close all,clc
%cal();
%function cal
I=imread('C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test1\exp1_001_b.bmp');
[count,bin]=imhist(I);
figure,imshow(I,[]);

B=im2bw(I);
figure,imshow(B,[]);
[L,n]=bwlabel(B);
figure,imshow(L,[]);

RGB=label2rgb(L);
figure,imshow(RGB,[]);

%%%White/Black
white=size(find(B(:)==1));
black=size(find(B(:)==0));
bwRatio=black/white;
bwRatio
[Ix,Iy]=size(I) 
n
for i=1:256
    count(i)=((i-1)/255)*count(i);
end
ratio=sum(count)/(Ix*Iy);


%%DIVIDE SUBIMAGE IA X IA
ia=8;
C = mat2cell(I,[ia*ones(1,Ix/ia),mod(Ix,ia)], [ia*ones(1,Iy/ia),mod(Iy,ia)]);
nL=zeros(size(C));
for i=1:size(C,1)
    for j=1:size(C,2)
        B=im2bw(C{i,j});
        %figure,imshow(B,[]);
        [L,n]=bwlabel(B);
        nL(i,j)=n;
    end
end
max(max(nL))
min(min(nL))
