clc,clear all,close all;
%cd('D:\Tubitak Server Files\Matlab Workshops\NanWoven\Pics')
img = imread('NonwovenFabric.jpg');

flatImg = double(reshape(img,size(img,1)*size(img,2),size(img,3)));
idx = kmeans(flatImg,2);
A=reshape(idx,size(img,1),size(img,2));
A(A==2)=0;
imgbw=logical(A);
imshow(imgbw,[])
%============== Filters image ===============%
for a = 1 : 6
  imgbw = medfilt2(imgbw);
end

%============= Counts objects ===============%
% Detects all object bounds (edges) in image,
% including hole bounds.
totalbound = bwboundaries(imgbw, 'holes');

% Detects all object bounds, excluding hole bounds.
objectcount = bwboundaries(imgbw, 'noholes');

% Outputs the result.
total_objects = size(objectcount, 1)
hole_objects = size(totalbound, 1) - size(objectcount, 1)
solid_objects = size(objectcount, 1) - hole_objects

%============= Image Labeling ===============%
L = bwlabel(imgbw, 8);

%============= Euler numbers ================%
s = regionprops(L, 'EulerNumber');
fprintf('Object NumbertEuler NumbertDescriptionn');
for i = 1 : total_objects
  fprintf('%dtttt%dtttt', i, s(i).EulerNumber);
  if (s(i).EulerNumber == 1) fprintf('solidn');
  else fprintf('holedn');
  end
end

%=========== Colorizes the regions ==========%
% Takes the pixels
PxList = regionprops(L, 'PixelList');

% Converts B&W image to RGB.
imgRGB = uint8(zeros(size(imgbw, 1), size(imgbw, 2), 3));

% For each object, do
for i = 1 : total_objects

  % Takes pixel list of this object
  plist = PxList(i).PixelList;

  % If the region has a hole
  if (s(i).EulerNumber == 0)
    % For each pixels
    for j = 1 : size(plist, 1)
        % Colorizes it with red
        imgRGB(plist(j, 2), plist(j, 1), 1) = 255;
    end

  % If the region has no hole
  else
    % For each pixels
    for j = 1 : size(plist, 1)
        % Colorizes it with green
        imgRGB(plist(j, 2), plist(j, 1), 2) = 255;
    end
  end
end

%=========== Displays the result ===========%
figure('Name', 'Membedakan Objek Padat dan Berlubang', 'NumberTitle', 'off');
subplot(1, 2, 1), imshow(img), title('Citra Asli');
subplot(1, 2, 2), imshow(imgRGB), title('Citra Hasil');