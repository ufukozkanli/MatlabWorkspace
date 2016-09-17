clc,clear all,close all
params(1)={'00020359.bmp'};
params(2)={'00020360.bmp'};
params(3)={'00020361.bmp'};
params(4)={'00020362.bmp'};


writerObj = VideoWriter('piv.avi');
open(writerObj);

%Z = peaks; surf(Z);
%axis tight
%set(gca,'nextplot','replacechildren');
%set(gcf,'Renderer','zbuffer');
for k = 0:15
    for i = 1:20
        %surf(sin(2*pi*k/20)*Z,Z)
        A=imread(params{mod(k,4)+1});
        imshow(A,[]);
        %pause(0.5)
        %imshow(A2,[]);
        frame = getframe;
        writeVideo(writerObj,frame);
    end
end

close(writerObj);