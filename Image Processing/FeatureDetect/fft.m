clc,clear all,close all;

%%
clc,clear all, close all;
a=[1 2 3;4 5 6;7 8 9];
a=double(uint8(rand(3,3).*100))
b=a-1;
b=magic(2);

T=4;
conv = ifft2(fft2(a,T,T) * fft2(b,T,T),T,T);
real(fftshift(conv));
corr = ifft2(fft2(a,T,T) .* conj(fft2(b,T,T)));
c=real(fftshift(corr))

xcorr2(a,b)

[maxColVal, maxColIdx] = max(c);
[maxRowVal, maxRowIdx] = max(maxColVal);
maxVal = maxRowVal;
maxValIdx = [maxColIdx(maxRowIdx), maxRowIdx]-size(a)
%%
%%%
% sz=size(c)
% for i=1:sz(1)
%     for j=1:sz(2)
%         if(xc==circshift(c,[i,j]))
%            [i,j]
%            3*N-2*V-1
%            %circshift(uint16(c),[i,j])
%         end
%     end
% end
%%
a=rand(100,100);
b=a-1;
tic
for i=1:100
    corr = ifft2(fft2(a,5,5) .* conj(fft2(b,5,5)));
    real(fftshift(corr));
    %xcorr2(a,b);
end
toc
%%

template=rand(10,10)
%template=ones(size(templateRaw)*2);
%template(3:size(templateRaw,1)+2,3:size(templateRaw,2)+2)=templateRaw

offset = [3 1];
offsetTemplateRaw=(template(offset(1):end,offset(2):end));

offsetTemplate=offsetTemplateRaw;
offsetTemplate = rand(size(template)); 
offsetTemplate(1:size(offsetTemplateRaw,1), 1:size(offsetTemplateRaw,2)) = offsetTemplateRaw
%I,I2 are reference and target images
%[row col] are row, column shifts
%SCd 4/2010
%
I=template;
I2=offsetTemplate;

%Fourier transform both images
fi = fft2(double(I));
fr = fft2(double(I2));

%Perform phase correlation (amplitude is normalized)
fc = fi .* conj(fr);
fcn = fc ./abs(fc);

%Inverse fourier of peak correlation matrix and max location
peak_correlation_matrix = abs(ifft2(fcn));
[peak, idx] = max(peak_correlation_matrix(:));

%Calculate actual translation
[row, col] = ind2sub(size(peak_correlation_matrix),idx)

%     if row < size(peak_correlation_matrix,1)/2
%         row = -(row - 1);
%     else
%         row = size(peak_correlation_matrix,1) - (row - 1);
%     end;
%     if col < size(peak_correlation_matrix,2)/2
%         col = -(col - 1);
%     else
% col = size(peak_correlation_matrix,2) - (col - 1);
%     end
