clc,clear all,close all;


for i=1:100;
n_frames = i;
%IA_ROW_COUNT = 16;
%IA_COL_COUNT = 40;
MAX_DISP = [2 5];
variationCoeff = 0.1; 
MAX_VAR_COEFF = MAX_DISP * variationCoeff;


t  = linspace(0,1,n_frames);
X_data = (sin(2*pi * t)) * MAX_DISP(2) + (randn(size(t)) * MAX_VAR_COEFF(2)) ;% Generate Sine Wave
subplot(211);
title('X');
plot(X_data);
axis([0 100 -10 10]);

Y_data = (sin(2*pi * t)) * MAX_DISP(1) + (randn(size(t)) * MAX_VAR_COEFF(1)) ;% Generate Sine Wave
subplot(212);
title('Y');
plot(Y_data);

axis([0 100 -5 5]);
drawnow;
pause(0.1);
end