clc,clear all,close all
%2. derece türev fonkisyonu
f=@(x)(sin(x));
%aral?k
h=1;
%türev al?nacak nokta
x=pi/6;




%3 nokta
r3 = (f(x-h) - 2*f(x) + f(x+h))/(h^2)
%5 nokta
r5 = ( -f(x-2*h)+ 16*f(x-h) - 30*f(x) + 16*f(x+h) - f(x+2*h))/(12*h^2)
%7 nokta
r7 = ( 2*f(x-3*h) - 27*f(x-2*h) + 270*f(x-h) -490*f(x)+ 270*f(x+h) - 27*f(x+2*h) + 2*f(x+3*h)) /(180*h^2)
