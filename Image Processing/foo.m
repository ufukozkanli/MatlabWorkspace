clc,clear all,close all;

IAS=2;
SZ=2*IAS-1;
a=randi([1 9],IAS,IAS);
%a(a<128)=0;
%a(a>=128)=255
b=randi([1 9],IAS,IAS);%circshift(a,[2 1])
%b(b<128)=0;
%b(b>=128)=255
%real(fft2(a).*fft2(b))

fftres=real(ifft2(fft2(a,SZ,SZ).*fft2(b,SZ,SZ)))
fftres=real(ifft2(fft2(a).*fft2(b)))
fftres=conv2(a,b)

fftres=ifft2(fft2(a).*fft2(b))
fftres=ifft2(fft2(a,SZ,SZ).*fft2(b,SZ,SZ))

[max_cc, imax] = max(fftres(:));

[ypeak, xpeak] = ind2sub(size(fftres),imax(1))

cc=xcorr2(b,a)

[max_cc, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1))
corr_offset = [(xpeak-size(a,2)) (ypeak-size(a,1))];
%max(max(res))
%ffta=fft2(single(a2),NfftHeight,NfftWidth);
%fftb=fft2(single(b2),NfftHeight,NfftWidth);

%c = real(ifft2(ffta.*fftb));
a=rand(5,1);
b=rand(5,1);
corrLength=length(a)+length(b)-1;

c=fftshift(ifft(fft(a,corrLength).*conj(fft(b,corrLength))))
xcorr(a,b)



template = .2*ones(11);
template(6,3:9) = .6;
template(3:9,6) = .6;
offsetTemplate = .2*ones(22);
offset = [8 6];
offsetTemplate( (1:size(template,1))+offset(1),...
                    (1:size(template,2))+offset(2) ) = template;
imagesc(offsetTemplate); colormap gray;
hold on;
imagesc(template);
cc = xcorr2(offsetTemplate,template)
[max_cc, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1))
corr_offset = [ (ypeak-size(template,1)) (xpeak-size(template,2)) ];
isequal(corr_offset,offset)



templateRaw=rand(4,4);
template=ones(size(templateRaw)*2);
template(3:size(templateRaw,1)+2,3:size(templateRaw,2)+2)=templateRaw

offset = [3 5];
offsetTemplateRaw=(template(offset(1):end,offset(2):end));

%offsetTemplate=offsetTemplateRaw;
offsetTemplate = ones(size(template)); 
offsetTemplate(offset(1):end, offset(2):end) = offsetTemplateRaw

cc = xcorr2(offsetTemplate,template)
[max_cc, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
corr_offset = [ (ypeak-size(template,1)) (xpeak-size(template,2)) ]