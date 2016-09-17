syms x y a1 a2 p0
phi=a1*(1-x^2)*(1-y^2)+a2*(1-x^2)*(1-y^2)*(x^2+y^2);
I=diff(phi,x)^2+diff(phi,y)^2-2*p0*phi
sumx=int(I,x,-1,1)
sumy=int(sumx,y,-1,1)
diff(sumy,a1)
diff(sumy,a2)
solve(diff(sumy,a1),diff(sumy,a2))
