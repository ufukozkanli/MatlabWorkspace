function main
clc, clear,imtool close all ,close all
draw();


function draw
addpath(genpath('C:/Users/NobodyAir/Desktop/Google Drive/Matlab/Image Processing/YkImageTools'));
IM_SIZE = [480 640];
IA_SIZE = 32;
NUMBER_OF_FRAMES = 10;
%DENSITY = 0.5;
V = 28;
MAX_DIS = IA_SIZE - V;

%im=uint8(ones(IM_SIZE));

IA_COUNT = floor(IM_SIZE./IA_SIZE);
IA_OFFSET = IM_SIZE - IA_COUNT * IA_SIZE;



IA_VEL = getVelVectors([NUMBER_OF_FRAMES ,IA_COUNT],MAX_DIS);

[ROLL_IMG,POS] = getRollImage(IM_SIZE,NUMBER_OF_FRAMES,MAX_DIS);

FRM_CUR = uint8(zeros(IM_SIZE));
%FRM_CUR = ROLL_IMG(POS(1) : IM_SIZE(1) + POS(1) - 1,POS(2) : IM_SIZE(2) + POS(2) - 1);

for f=1:NUMBER_OF_FRAMES
    for i=1:IA_COUNT(1)
        for j=1:IA_COUNT(2)
            try
                dx = sum(IA_VEL(1:f,i,j,2));
                dy = sum(IA_VEL(1:f,i,j,1));
                
                MOVED_IA_POS = [POS(1) + dy , POS(2) + dx ];
                IA_RECT = [(i-1) * IA_SIZE + 1 ,(j-1) * IA_SIZE + 1 , i * IA_SIZE ,j * IA_SIZE];
                
                %[IA_RECT(1) , IA_RECT(3) , IA_RECT(2) , IA_RECT(4) ];
                %[MOVED_IA_POS(1) + IA_RECT(1) , MOVED_IA_POS(1) +  IA_RECT(3) , MOVED_IA_POS(2) +  IA_RECT(2) , MOVED_IA_POS(2) +  IA_RECT(4)];
                FRM_CUR(IA_RECT(1) : IA_RECT(3) , IA_RECT(2) : IA_RECT(4)) = ROLL_IMG(...
                    MOVED_IA_POS(1) + IA_RECT(1) : MOVED_IA_POS(1) +  IA_RECT(3) ,...
                    MOVED_IA_POS(2) +  IA_RECT(2) : MOVED_IA_POS(2) +  IA_RECT(4));
            catch exception
                warning(exception);
            end
        end
    end
    imshow(FRM_CUR,[]);
    pause(0.5);
end

function VEL = getVelVectors(varargin)
mat = varargin{1};

VEL=int8(rand([mat(1) + 1 , mat(2) , mat(3) , 2]) * (varargin{2} + 1));
VEL(1,:,:,1:2) = 0;

function [IMG,START_POS] = getRollImage(varargin)
%vel = varargin{1};
%vx = reshape(vel(:,:,:,2),size(vel,1),[]);
%[max_x, position] = max(vx);
%[max_y, position] = max(vel(:,:,:,1));
size = varargin{1};
num_fr = varargin{2};
max_dis = varargin{3};
tot_dis = num_fr * max_dis * 2;
size = [size(1)+ tot_dis,size(2) + tot_dis];

%IMG = imresize(rgb2gray(imread('tissue.png')),size);
IMG = getImage(size);

START_POS = [tot_dis/2,tot_dis/2];

function IMG = getImage(varargin)
size_Image = varargin{1};

IMG = uint8(zeros(size_Image));


%IMG = imresize(rgb2gray(imread('tissue.png')),size);

oval_size = 5;
circle = uint8(zeros(oval_size));
circle = drawOvalFill(circle, [ 1 1 size(circle)], 255);
%imshow(circle,[]);

for i=1:10000
    pos = ceil(rand(1,2) .* size_Image);
    try
        %[pos(1),pos(1) + oval_size , pos(2),pos(2) + oval_size];
        IMG(pos(1):pos(1) + oval_size - 1 , pos(2):pos(2) + oval_size - 1) = circle;
    catch ex
        warning(ex.getReport);
    end
    %IMG = drawOvalFill(IMG, [pos pos + oval_size ], 56 + rand(1) * 200);
    %drawOvalFill(im, [50 50 53 53], 255);
    %drawOvalFrame(IMG, [50 50 90 90], 0.5, 255);
    %drawPolygon(IMG, [10 10 ; 90 30 ;  90 90], 255);
    %drawRectFill(IMG, [20 20 50 50], 255);
end
%imshow(IMG,[]);
%display('');
