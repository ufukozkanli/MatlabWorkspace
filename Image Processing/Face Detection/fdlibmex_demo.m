% ---------------------------------------------------------------------
% fdlibmex_demo.m
%
% illustrates the usage of the fdlibmex face detection library by
% two examples
%

clear all
close all

% set mex file path for this platform ..
addpath(lower(computer));

% call without arguments to display help text ...
fprintf('\n--- fdlibmex help text ---\n');
fdlibmex

% Create video input object. 
vid = videoinput('winvideo');
set(vid, 'ReturnedColorSpace', 'RGB');

% Set video input object properties for this application.
% Note that example uses both SET method and dot notation method.
set(vid,'TriggerRepeat',Inf);
vid.FrameGrabInterval = 1;

% Set value of a video source object property.
vid_src = getselectedsource(vid);
set(vid_src,'Tag','motion detection setup');

% Create a figure window.
figure; 

% Start acquiring frames.
start(vid)

% Calculate difference image and display it.
while(vid.FramesAcquired<=Inf) % Stop after 100 frames

    data = getdata(vid,2); 
    %diff_im = imabsdiff(data(:,:,:,1),data(:,:,:,2));
    %imshow(diff_im);
    img=rgb2gray(data(:,:,:,1));
    
    pos = fdlibmex(img);

    % display the image
    imagesc(img)
    colormap gray
    axis image
    axis off

    % draw red boxes around the detected faces
    hold on
    for i=1:size(pos,1)
        r = [pos(i,1)-pos(i,3)/2,pos(i,2)-pos(i,3)/2,pos(i,3),pos(i,3)];
        rectangle('Position', r, 'EdgeColor', [1,0,0], 'linewidth', 2);
    end
    hold off
end
% show stats
fprintf('\n--- fdlibmex example ---\n');
fprintf('\n\t%d faces detected in \''%s\'' (see figure 1)\n\n', ...
    size(pos,1), imgfilename);
stop(vid)
