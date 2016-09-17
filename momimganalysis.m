function output=momimganalysis(E0,fr,a,zmax,xs,zo,xo,NX,NZ,numimg,pol)
% MOM analysis with image method inside a 2D-PEC parallel plate waveguide
% for the calculation of
% Field vs Range at a given height (xo)
% Field vs Height at a given range (zo)
%
% E0: Field amplitude, fr: frequency [MHZ], a: plate height [m], zmax: maximum range [m]
% xs: source height [m], xo: observer height [m], zo: observer range [m]
% NX: number of height points, NZ: number of range points,
% numimg: number of image
% pol: polarization type, 0 for TEz case, 1 for TMz case
%
% output.zz: range points, output.xx: height points
% output.Fhl: horizontal ?eld at x=xo
% output.Fv0: vertical ?eld at z=0
% output.Fvl: vertical ?eld at z=zo
%--------------------------------------------------------------------------
k0=2*pi*fr'/300; % wavenumber in free space
dx=a/(NX-1); dz=zmax/(NZ-1);
xx=(0:dx:a).';
zz=(0:dz:zmax); zz=0.5*(zz(l: end-l)+zz(2:end)); Nz=length(zz);
% Calculate initial voltages on the surface coming from source at (0,xs)
% lower part at x=0
dsl=sqrt(xs^2+zz.^2); inc_fldl=exp(-li*k0*dsl)./sqrt(k0*dsl);
% upper part at x=a
ds2=sqrt((a-xs)^2+zz.^2); inc_fld2=exp(-1i*k0*ds2)./sqrt(k0*ds2);
V_incl=-inc_fldl; V_inc2=-inc_fld2;
% Calculate the impedance matrix
if pol==l % TMz (vert. case)
in1p__matrixl=0.5*eye(Nz); imp_matrix2=0.5*eye(Nz);
elseif pol==0 % TEz (hor. case)
imp_matrix l=zeros(2*Nz- I , l );
for m=l :Nz-l
dd=dz*m;
imp_matrixl(Nz+m,l)=-0.25*dz*l20*pi*k0*besselh(0,2,k0*dd);
end
imp_matrix l (1 :Nz-1 )=imp_matrixl(2*Nz-l :-l :Nz+ 1);
in1p_matrixl(Nz,l)=-0.25*dz*l20*pi*k0*...
(l-li*2/pi*log(exp(0.577215665)*k0*dz/(4*exp( l))));% if m==n
imp_matrix l =meshgrid(imp_matrix 1 ,ones(Nz, 1));
imp_matrix l =spdiags(i1np_1natrixl ,-(Nz- 1 ):Nz-l ,Nz,Nz);
in1p_matrixl=full(imp_matrix1);
imp_matrix2=imp_matrixl ;
end
ind_currentl=imp_matrixl\V_incl.'; ind_current2=imp_matrix2\V_inc2.';
% ------------------ RANGE PROFILE --------------------
scat_ver0=zeros(NX,1 ); scat_ver1 =zeros(NX, 1 ); % scattering ?elds
for m=l :Nz
% lower part at x=0
for ii=0:numimg,
if mod(ii,2)==0, kkk=xx+ii*a; else kkk=-xx+(ii+1)*a; end

s1 =findscatfld(ind_current1 (m),k0,0,kkk,zz(m),pol);
if pol==0
scat_ver0=scat_ver0+(- 1 )^ii*sl ;
elseif pol==l
scat_ver0=scat_ver0+sl ;
end
s1 =findscatfld(ind_currentl (m),k0,z0,kkk,zz(m),pol);
if pol==0
scat_ver1 =scat_ver1 +(- 1 )^ii*s1 ;
elseif pol==1
scat_verl =scat_verl +s1 ;
end
end
% upper part at x=a
for ii=0:numimg,
if mod(ii,2)==0, kkk=-xx+(ii+l)*a; else kkk=xx+ii*a; end
s2=findscatfld(ind_current2(m),k0,0,kkk,zz(m),pol);
if pol==0
scat_ver0=scat_ver0+(- l )^ii *s2;
elseif pol==l
scat_ver0=scat_ver0+s2;
end
s2=findscatfld(ind_current2(m),k0,zo,kkk,zz(m),pol);
if pol==0
scat_ver l =scat_verl +(- l )"ii *s2;
elseif pol==l
scat_verl =scat_verl +s2;
end
end
end
if pol==l, % TMz (ver)
dist=sqrt((xx-xs).^2+0.^2);
inc_ver0=exp(-1i*k0*dist)./sqrt(k0*dist);
tot_ver0=inc_ver0+0.25*dz* li*k0* scat_ver0;
dist=sqrt((xx-xs).^2+zo.^2);
inc_verl =exp(-1i*k0*dist)./sqrt(k0*dist);
tot_verl =inc_verl +0.25*dz*1i*k0* scat_verl ;
elseif pol==0 % TEZ (hor)
dist=sqrt((xx-xs).^2+0.^2);
inc_ver0=exp(-1i*k0*dist)./ sqrt(k0*dist);
tot_ver0=inc_ver0-0.25*dz* 120* pi *k0*scat_ver0;
dist=sqrt((xx-xs).^2+zo.^2);
inc_verl=exp(-1i*k0*dist)./sqrt(k0*dist);
tot_ver1 =inc__verl -0.25*dz* l20*pi *k0*scat__verl ;
end
scat_h0r=zeros(l,Nz); % scattering ?elds
for m=l :Nz
% lower part at x=0
for ii=0:numimg,
if mod(ii,2)==0, kkk=x0+ii*a; else kkk=-xo+(ii+l)*a; end
s 1 =?ndscat?d(ind_currentl (n1),k0,zz,kkk,zz(n1),pol);
if pol==0
scat_hor=scat_horl-(-l )^ii*s1 ;
elseif pol==1

scat_hor=scat_hor+sl ;
end
end
% upper part at x=a
for ii=0:numimg,
if m0d(ii,2)==0, kkk=-x0+(ii+l)*a; else kkk=x0+ii*a; end
s2=findscatfld(ind_current2(m),k0,zz,kkk,zz(m),pol);
if pol==0
scat_hor=scat_hor+(-1 )^ii* s2;
elseif pol==l
scat_hor=scat_hor+s2;
end
end
end
dist=sqrt((x0-xs)^2+zz.^2);
inc_hor=exp(-1i*k0*dist)./sqrt(k0*dist);
if pol==1 ,
tot_hor=inc_hor-l-0.25*dz* 1i*k0*scat_hor;
elseif pol==0
tot_hor=inc_hor-0.25 *dz* l20*pi*k0*scat_hor;
end
if p0l==l, % TMZ (ver)
tot_ver0=E0/( 120*pi)*t0t_ver0; tot_verl=E0/( 120*pi)*tot_verl ;
t0t_h01=(E0/ 120*pi)*t0t_h0r;
elseif pol==0, % TEz (hor)
tot_ver0=E0*t0t_ver0; tot_verl=E0*tot_verl; tot_hor=E0*tot_hor;
end
output.xx=xx; output.zz=zz;
output.Fv0=tot_ver0; output. Fvl =tot_verl ; output.Fh1 =tot_hor;
function scat_mag=findscatfld(ind_current,k0,zobs,xobs,zs,pol)
dd=sqrt(xobs.^2+(zobs-zs).^2);
if pol==l , % TMz (vet)
prinner=abs(xobs)./dd;
scat_mag=ind_current.*besseIh( I ,2,k0*dd).*prinner;
elseif pol==0 % TEz (hor)
scat_mag=ind_current.*besselh(0,2,k0*dd);
end

