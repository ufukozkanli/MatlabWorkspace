% Create an array of filenames that make up the image sequence
fileFolder = fullfile(matlabroot,'toolbox','images','imdemos');
dirOutput = dir(fullfile(fileFolder,'AT3_1m4_*.tif'));
fileNames = {dirOutput.name}';
numFrames = numel(fileNames);

I = imread(fileNames{1});

% Preallocate the array
sequence = zeros([size(I) numFrames],class(I));
sequence(:,:,1) = I;

% Create image sequence array
for p = 2:numFrames
    sequence(:,:,p) = imread(fileNames{p}); 
end