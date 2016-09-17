clc,clear all,close all
n = 67
sqrt(n)
q = n;
p = 0;

nStemp = 1;
acc = 10e-6;

while( abs(n - (nStemp^2)) >acc)
    nStemp = (p+q)/2
    
    if((n - (nStemp^2)) < 0)
        q = nStemp;
    else
        p = nStemp;
    end
        
end