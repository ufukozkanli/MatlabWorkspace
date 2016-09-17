clear classes
function util
res=vision(0.2,@callMain);

function fileName
fileName=strcat(datestr(clock,'yyyy-mm-dd-HHMM'),'m',datestr(clock,'ss'),'s','.txt');
function tyt
subplot(1,4,1),imshow(uint8(AvgFrame),[]),title('Background calculated : AvgFrame');

function figureSetName(id,name)
figure(id),
set(gcf, 'name',name);
function tt(a,b)
a(b);

function tt
hFig = figure(1);
set(hFig, 'Position', [x y width height])

function histogram(grayImage)
%h = hist(grayImage,255); %D is your data and 140 is number of bins.
%h = h/sum(h); % normalize to unit length. Sum of h now will be 1.
%figure(100), bar(h, 'DisplayName', 'Travel Distance'); 
%legend('show');
edges = [0:1:2 10];
h = histogram(grayImage,edges);

function webcam()
info=imaqhwinfo;
for i=1:numel(info.InstalledAdaptors)
    adapt=info.InstalledAdaptors{i} 
    adaptInfo=imaqhwinfo(adapt)
    for j=1:numel(adaptInfo.DeviceIDs)
        devId=adaptInfo.DeviceIDs{j};
        device=imaqhwinfo(adapt,devId)
        %for k=1:numel(device.SupportedFormats)
            supp=device.SupportedFormats
         obj = videoinput(adapt,devId)
         obj_info = imaqhwinfo(obj)
        
         %frame = getsnapshot(obj);
         start(obj);
         while 1==1            
            data = getdata(obj);
            size(data)
            %imshow(data,[])
         end
        delete(obj);
        %end
    end
end

function pictures=vision(t,func)
n=50;
 %n=number of pictures, t=time;
 %Defining the video input object
 camara=videoinput('winvideo',1);
 set(camara,'SelectedSourceName','input1');
 %Fixing the frames per trigger in 1
 set(camara,'FramesPerTrigger',1)
 %Manual configuration of the webcam
 triggerconfig(camara,'manual');
 %RGB configuration
 set(camara,'ReturnedColorSpace','rgb');
 %Infinite triggers
 set(camara,'TriggerRepeat',Inf);
  try 
     start(camara);
     counter=0;
     while (camara.FramesAcquired<n)
        trigger(camara);
        %Recover frames captured from the buffer
        %pictures(:,:,:,camara.FramesAcquired)=getdata(camara,1);   

        func(getdata(camara,1));

        pause(t);
        counter=counter+1;
        fprintf('FRAME %d\n',counter);
        disp('');
     end;
     stop(camara);
     delete(camara);

 catch exception
    stop(camara);
    delete(camara);
    % Rethrow original error.
    rethrow(exception)
 end  
 pictures=1;

function callMain(I)
figure(100),imagesc(double(rgb2gray(I)));
function dk=getDesktop
 winqueryreg('HKEY_CURRENT_USER', 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'Desktop')
function filterMult
aFiltered=a.*(repmat(a(:,:,1)>0.5,[1,1,3]));
%f1.*uint8(repmat(f1(:,:,1)>100,[1,1,3]));
function moveDataToBaseWorkspace
assignin('base','ProcessedData1',f1)
function VelocityNonzeroDisplay
nonZeroDisp=(avg(:,:,1)~=0 + avg(:,:,2)~=0);
[row,col] = find(nonZeroDisp==1);
VY=avg(sub2ind(size(avg),row,col,ones(size(row,1),1)));
VX=avg(sub2ind(size(avg),row,col,ones(size(row,1),1)*2));
quiver(col,row,VX,VY);