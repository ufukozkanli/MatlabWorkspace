function main
clc,clear%,close all
%b();
c();
function c


function a




for i=1:2
    f=sprintf('ripple%d',i);
    a=imread(sprintf('D:\\Matlab Workshops\\My\\PIV TEST\\Test Pics\\%s.bmp',f));
    fid = fopen(sprintf('%s.txt',f),'w');
    a=uint8(a);
    a=flipud(a);
    fprintf(fid,'%d %d \n',size(a));
    fprintf(fid,'%d ',a');
    fclose(fid);
end




function b
%%
fid = fopen('C:\Users\zirve\Documents\Visual Studio 2010\Projects\T3300\TestBook1\tmp\coordOfMaxIAs.txt');
textscan(fid,'%s\t%s\t%s\t%s\n');
SIZES=textscan(fid,'%d\t%d\t%d\n');
SIZES=double(cell2mat(SIZES));
N=SIZES(3);
sz=[SIZES(1),SIZES(2)];
IAC=floor(sz./N)
movres=zeros([IAC,2]);

while ~feof(fid)
    C=textscan(fid,'%d %d %d %d\n');
    if(isempty(C{1}))
        break;
    end
    eval(sprintf('movres(%d,%d,:)=[-%d %d];',C{1},C{2},C{4},C{3}));
end

% for i=1:IAC(1)
%     for j=1:IAC(2)
%         C=textscan(fid,'%d %d %d %d\n');
%         movres(i,j,:) = [C{3} C{4}];        
%     end
% end
fclose(fid);
%%
a1=imread('D:\Matlab Workshops\My\PIV TEST\Test Pics\ripple1.bmp');

for i = 1 : 2
    movres(:, :, i) = flipud(movres(:, :, i));
end


figure('Name','GPU')
imshow(a1),hold on
quiver(N/2:N:N*IAC(2),N/2:N:N*IAC(1),movres(:,:,2),movres(:,:,1),'g')
hold off

return
%%
for i = 1 : 2
    movres(:, :, i) = flipud(movres(:, :, i));
end
fid = fopen('temp.txt','w');
fprintf(fid,'ROW\tCOL\tN\n');
fprintf(fid,'%d\t%d\t%d\n',size(a1,1),size(a1,2),N);
for i=1:size(movres,1)
    for j=1:size(movres,2)
        fprintf(fid,'%d\t%d\t%d\t%d\t\n',i, j, movres(i,j,2), movres(i,j,1));
    end
end
fclose(fid);




