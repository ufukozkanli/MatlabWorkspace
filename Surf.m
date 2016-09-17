clear all close all clc

x=-2:0.1:2;
y=-2:0.1:2;
[X Y]=meshgrid(x,y);
F=4*X.^2+Y.^2;
surf(X,Y,F);

shading interp

for i=1:14
    %if(mod(4*i,26)==(mod(19*i,26)+3))
     %   display([i 4*i 19*i mod(4*i,26) mod(19*i,26)])
    %end
    %if(mod(7^i,14)==12)
    %   disp([i])
    %end
    %if(mod(7^i,13)==1)
        %disp([i mod(5^i,23)])
    %end
        disp([i mod(7^i,11)  ])
    %display('seres' +[i 4*i 19*i mod(4*i,26) mod(19*i,26)])
end