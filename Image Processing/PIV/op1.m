function main
clc, clear,imtool close all ,close all
params(1)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test1\exp1_001_b.bmp'};
params(2)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test1\exp1_001_c.bmp'};
params(3)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test2\00020359.bmp'};
params(4)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\OPENPIV\openpiv-matlab-master\openpiv-matlab-master\test2\00020360.bmp'};
params(5)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\Example Pics\PTVlab_gen_01.tif'};
params(6)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\Example Pics\PTVlab_gen_02.tif'};
params(7)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\Example Pics\PTVlab_gen2_01.tif'};
params(8)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\Example Pics\PTVlab_gen2_02.tif'};
params(9)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\Example Pics\PTVlab_gen3_01.tif'};
params(10)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\Example Pics\PTVlab_gen3_02.tif'};
params(11)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\Example Pics\PTVlab_gen4_01.tif'};
params(12)={'C:\Users\NobodyAir\Desktop\Google Drive\TubitakGpu\Codes\Example Pics\PTVlab_gen4_02.tif'};
xcorr(params);

function xcorr(params)
N=32;%IA Size
V=26;%Overlapping Size 
NDV=N-V;%MAX Displacement in each Direction
fftSize=4*N-2*V-1;
a1 = imread(cell2mat(params(3)));
b1 = imread(cell2mat(params(4)));
a1(a1==0)=1;
b1(b1==0)=1;
%a1=imresize(a1,0.5);
%b1=imresize(b1,0.5);
a=double(a1);
b=double(b1);

% N=3;
% V=1
% a=double(int8(rand(10,10).*100)./10-1)
% b=padarray(a,[2 2]);
% b=circshift(b,[0,-2])

sz=size(a);
IAC=floor(sz./N);

bNew=padarray(b,[N-V N-V],0);
movres1=zeros(IAC(1),IAC(2),2);
movres2=zeros(IAC(1),IAC(2),2);
movres3=zeros(IAC(1),IAC(2),2);
tic
figure
for i=1:IAC(1)
    for j=1:IAC(2)
        %%        
        ia = a((i-1)*N+1:i*N , (j-1)*N+1:j*N);
        %%        
        sw=bNew((i-1)*N+1:i*N+2*NDV , (j-1)*N+1:j*N+2*NDV);
        corr = ifft2(fft2(ia,fftSize,fftSize) .* conj(fft2(sw,fftSize,fftSize)));
        c=real(corr);
        %xcorrRes=xcorr2(ia,sw);
        %%        
        c=circshift(c,[3*N-2*V-1,3*N-2*V-1]);        
        %%
        %surf(c);zlim([0,15e4])
        %drawnow;
        %%
        szxc=size(c);
        [maxColVal, maxColIdx] = max(c);
        [maxRowVal, maxRowIdx] = max(maxColVal);
        %maxVal = maxRowVal;
        maxValIdx = [maxColIdx(maxRowIdx), maxRowIdx];
        movres3(i,j,:)= (szxc+1)/2-maxValIdx;
        %continue;
        %        
%         inds
%         ia
%         sw
%         maxValIdx
%         maxValIdx-[(N-V) (N-V)]
%         xcorrRes
%         c
        %
        diffres=zeros(2*NDV+1,2*NDV+1,3);
        corres=zeros(2*NDV+1,2*NDV+1,3);
 
        for iy=-(N-V):N-V
            for ix=-(N-V):N-V                
                cw=bNew((i-1)*N+1+iy+NDV:i*N+iy+NDV , (j-1)*N+1+ix+NDV:j*N+ix+NDV);
                %%
                sm=sum(sum(abs(cw-ia)));
                
                diffres(iy+NDV+1,ix+NDV+1,:)=[ix iy sm ];
                %%
                sm2=sum(sum(cw.*ia));
                corres(iy+NDV+1,ix+NDV+1,:)=[ix iy sm2];
                %%
                %if(ix==0 && iy==2 )%&& i==5 && j==5
                %sm;
                %end
                %[ix iy];
            end
        end
        %%
        [minColVal, minColIdx] = min(diffres(:,:,3));
        [minRowVal, minRowIdx] = min(minColVal);
        %minVal = minRowVal;
        minValIdx = [minColIdx(minRowIdx), minRowIdx];
        movres1(i,j,:)=diffres(minValIdx(2),minValIdx(1),1:2);               
        %%
        [maxColVal, maxColIdx] = max(corres(:,:,3));
        [maxRowVal, maxRowIdx] = max(maxColVal);
        %maxVal = maxRowVal;
        maxValIdx = [maxColIdx(maxRowIdx), maxRowIdx];
        movres2(i,j,:)=corres(maxValIdx(2),maxValIdx(1),1:2);
        %%
        %[corx cory] = find(corres(:,:,3)==min(min(corres(:,:,3))));
        %corres(i,j,:)=[corx(1)-(N-V)-1,cory(1)-(N-V)-1];
    end
end
toc
figure
imshow(a1),hold on
quiver(N/2:N:N*IAC(2),N/2:N:N*IAC(1),movres1(:,:,2),movres1(:,:,1))
hold off
figure
imshow(a1),hold on
quiver(N/2:N:N*IAC(2),N/2:N:N*IAC(1),movres2(:,:,2),movres2(:,:,1))
hold off
figure
imshow(a1),hold on
quiver(N/2:N:N*IAC(2),N/2:N:N*IAC(1),movres3(:,:,2),movres3(:,:,1))
hold off

return
%%
IAS1=zeros(IAC(1),IAC(2),N,N);
%IAS2=zeros(IAC(1),IAC(2),N,N);
for i=1:IAC(1)
    for j=1:IAC(2)
        IAS1(i,j,:,:) = a((i-1)*N+1:i*N,(j-1)*N+1:j*N);
        %IAS2(i,j,:,:) = b((i-1)*N+1:i*N,(j-1)*N+1:j*N);
    end
end