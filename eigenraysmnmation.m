function output=eigenraysmnmation(E0,fr,a,zmax,xs,zo,x0,NX,NZ,nray,p0l)
% EigenRay Summation inside a 2D-PEC parallel plate waveguide
% for the calculation of
% Field vs Range at a given height (xo)
% Field vs Height at a given range (zo)
%
% E0: Field amplitude, nray: number of re?ections
% fr: ?equency [MHz], a: plate height [m], zmax: maximum range [m]
% xs: source height [m], zo: observer range [m], xo: observer height [m]
% NX: number of height points, NZ: number of range points
% nray: number of rays
% pol: polarization type, 0 for TEZ case, l for TMZ case
%
% output.zz: range points
% output.xx: height points
% output.fx0: vertical ?eld at z=0
% output.fx: vertical ?eld at z=zo
% output.fz: horizontal ?eld at x=xo
%--------------------------------------------------------------------------
k0=2*pi*fr/300; % wavenumber in free space
xx=(0:a/(NX-l):a).';
zz=(0:zmax/(NZ-l ):zmax).'; zz=0.5*(zz(1 :end- 1 )+zz(2:end));
Fv0=zeros(NX,1); Fvl=zeros(NX, 1); Fhl =zeros(length(zz), 1);
% Field vs Height at z=0
for k=l :NX
g1=0; g2=0; g3=0; g4=0;
for n=0:nray
qq1= abs(xx(k)-xs)+2*a*n;
qq2= abs(xx(k)+xs)+2*a*n;
qq3=-abs(xx(k)+xs)+2*a*(n+l);
qq4=-abs(xx(k)-xs)+2*a*(n+1);
% Calculate four rays
gl =gl+1i/(4*pi)*sqrt((2*pi*1i)/(k0*-qq1 ))*exp(-1i*k0*qq1);
g2=g2+1i/(4*pi)*sqrt((2*pi*1i)/(k0*-qq2))*exp(-1i*k0*qq2);
g3=g3+1i/(4*pi)*sqrt((2*pi* 1i)/(k0*-qq3))*exp(-1i*k0*qq3);
g4=g4+1i/(4*pi)*sqrt((2*pi* 1i)/(k0*-qq4))*exp(-1i*k0*qq4);
end
if pol==0,
Fv0(k)=Fv0(k)+g1-g2-g3+g4;
elseif pol==l
Fv0(k)=Fv0(k)+g1 +g2+g3+g4;
end
end
% Field vs Height z=zo
for k=l :NX
g1=0; g2=0; g3=0; g4=0;
for n=0:nray
qql=@(t) abs(xx(k)-xs)*cos(t)+zo*sin(t)+2*a*n*cos(t);
qq2=@(t) abs(xx(k)+xs)*cos(t)+zo*sin(t)+2*a*n*cos(t);
qq3=@(t) -abs(xx(k)+xs)*oos(t)+zo*sin(t)+2*a* (n+ 1 )*cos(t);
qq4=@(t) -abs(xx(k)-xs)*cos(t)+zo* sin(t)+2*a*(n+l )*cos(t);
% Calculate eigenray angles
wn l =atan(z0/(abs(xx(k)-xs)+2 *a*n));
wn2=atan(zo/(abs(xx(k)+xs)+2*a*n));
wn3=atan(zo/(-abs(xx(k)+xs)+2*a*(n+1)));
wn4=atan(z0/(-abs(xx(k)-xs)+2*a*(n+1)));
% Calculate four rays
g1=g1+1i/(4*pi)*sqrt((2*pi*1i)/(k0*(-qql(wn1))))*exp(-1i*k0*qq1(wn1));
g2=g2+1i/(4*pi)*sq11((2*pi*1i)/(k0*(-qq2(wn2))))*exp(-1i*k0*qq2(wn2));
g3=g3+1i/(4*pi)* sqrt((2*pi*1i)/(k0*(-qq3(wn3))))*exp(-li*k0*qq3(wn3));
g4=g4+li/(4*pi)*sqrt((2*pi*1i)/(k0*(-qq4(wn4))))*exp(-li*k0*qq4(wn4));
end
if pol==0,
Fvl(k)=Fv1(k)+gl-g2-g3+g4;
elseif pol==1
Fvl(k)=Fvl(k)+gl+g2+g3+g4;
end
end
% Field vs Range at x=xo
for k=l :length(zz)
g1=0; g2=0; g3=O; g4=0;
for n=0:nray
qq1=@(t) abs(xo-xs)*c0s(t)+zz(k)*sin(t)+2*a*n*c0s(t);
qq2=@(t) abs(xo+xs)*cos(t)+zz(k)*sin(t)+2*a*n*cos(t);
qq3=@(t) -abs(x0+xs)*cos(t)+zz(k)*sin(t)+2*a*(n+ l)*c0s(t);
qq4=@(t) -abs(x0-xs)* cos(t)+zz(k)* sin(t)+2 *a* (n+ 1 )*cos(t);
% Calculate eigenray angles
wn1=atan(zz(k)/(abs(x0-xs)+2*a*n));
wn2=atan(zz(k)/(abs(x0+xs)+2*a*n));
wn3=atan(zz(k)/(-abs(x0+xs)+2*a*(n+1)));
wn4=atan(zz(k)/(-abs(x0-xs)+2*a*(n+1)));
% Calculate four rays
g1=g1+1i/(4*pi)*sqrt((2*pi*1i)/(k0*(-qql(wn1))))*exp(-1i*k0*qq1(wn1));
g2=g2+1i/(4*pi)* sqrt((2*pi*1i)/(k0*(-qq2(wn2))))*exp(-1i*kO*qq2(wn2));
g3=g3+1i/(4*pi)* sqrt((2*pi*1i)/(k0*(-qq3(wn3))))*exp(-1i*k0*qq3(wn3));
g4=g4+1i/(4*pi)* sqrt((2*pi*1i)/(k0*(-qq4(wn4))))*exp(-1i*k0*qq4(wn4));
end
if pol==0,
Fhl(k)=Fh1(k)+gl-g2-g3+g4;
elseif pol==1
Fhl(k)=Fh1(k)+g1+g2+g3+g4;
end
end
% Results
output.xx=xx; output.zz=zz;
if pol==0,
output.Fv0=E0*Fv0; output.Fv1=E0*Fvl ; output.Fhl=E0*Fh1 ;
elseif pol==l ,
output.Fv0=E0/(120*pi)*Fv0; output.Fvl=E0/(120*pi)*Fv1; output.Fh1=E0/(120*pi)*Fh1;
end


