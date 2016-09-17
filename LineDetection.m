%% PickLocateColor_MAIN.m
 
%% Clean up and load an image
clear all; close all; clc;
 
%% Choose and show an image
WhichOne = 2;
switch WhichOne
    case 1, load image6; ImageA = Snapshot;
    case 2, ImageA = imread('C:\Users\NobodyMacWin\Desktop\road1.jpg');
    case 3, ImageA = imread('road2.jpg');
    case 4, ImageA = imread('road3.jpg');
    case 5, ImageA = imread('road4.jpg');
    case 6, ImageA = imread('road5.jpg');
end
figure(3);
imshow(ImageA); hold on; drawnow;
 
%% Use GUI to pick a color
% W1 defines the diameter of the marker for picked color
% Delta defines the maximum deviation from the picked color
 
W1 = 10;   Delta = 10; 
%W1 = 15;   Delta = 8; 
set(gcf,'windowbuttondownfcn','PickLocateShow_3','windowbuttonupfcn','')
 
%% PickLocateShow3.m
clear Col Row

%% Get location of cursor & color of clicked pixel
imshow(ImageA); hold on; drawnow;
U_temp = get(gca,'currentpoint');
%Point = round(U_temp(1,2:-1:1))  
%Point=[1; 299];   % Note the order of the 2nd index is reversed.
Point=[299;1];
ImageA_Val = double(ImageA);
DesColor(1:3) = ImageA_Val(Point(1),Point(2),:);
%DesColor(1:3) = [200 200 200];
 
%% Find pixels of approximately the same color
Mask = abs(ImageA_Val(:,:,1)-DesColor(1)) < Delta & ...
           abs(ImageA_Val(:,:,2)-DesColor(2)) < Delta & ...
           abs(ImageA_Val(:,:,3)-DesColor(3)) < Delta;
[Row, Col] = find(Mask);
plot(Col,Row,'.','color',[0 1 1]);   drawnow;
 
%% Plot a circle to show clicked location
Angles = [0:0.3:6.28];
Circle = [W1*cos(Angles)+Point(2)*ones(1,length(Angles));
         W1*sin(Angles)+Point(1)*ones(1,length(Angles))];
plot(Circle(1,:),Circle(2,:),'.y','markersize',5);  drawnow;
hold off