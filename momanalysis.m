function output=momanalysis(E0,fr,a,zmax,xs,xo,NX,NZ,numitr,pol)
% MOM analysis inside a 2D-PEC parallel plate waveguide
% for the calculation of
% Field vs Range at a given height (xo)
%
% E0: Field amplitude
% fr: frequency [MHz], a: plate height [m], zmax: maximum range [m]
% xs: source height [m], xo: observer height [m]
% NX: number of height points, NZ: number of range points,
% numitr: number of iteration
% pol: polarization type, 0 for TEz case, I for TMz case
%
% output.zz: range points
% output.xx: height points
% output.Fhl: horizontal ?eld at x=xo
%-------------------------------------------------------»-----------------
k0=2*pi*fr/300; % wavenumber in free space
dx=a/(NX-1); dz=zmax/(NZ-l);
xx=(0:dx:a).';
zz=(0:dz:zmax);
xter=zeros(size(zz));
zz=0.5*(zz(l :end- l )+zz(2:end)); Nz=length(zz);
FF=zeros(NX,NZ-1);
%% Calculate the impedance matrix
if pol==l % TMz (vert. case)
imp_matrixl=0.5*eye(Nz); imp_matrix2=0.5*eye(Nz);
elseif pol==0 % TEz (hor. case)
imp_matrix1 =zeros(2*Nz-1 ,1 );
for m=l :Nz-1
dd=dz*m;
imp_matrixl (Nz+m, 1 )=-0.25*dz* l20*pi*k0*besselh(0,2,k0*dd);
end
imp_matrixl (1 :Nz-1)=imp_matrixl(2*Nz-1 :-1 :Nz+ 1 );
imp_matrixl(Nz,l)=-0.25*dz* l20*pi*k0*...
(1-1i*2/pi*log(exp(0.577215665)*k0*dz/(4*exp( 1 ))));% if m==n
imp_matrixl=meshgrid(imp_matrix1 ,ones(Nz, 1));
imp_matrixl=spdiags(imp_matrix1 ,-(Nz- 1 ):Nz-1 ,Nz,Nz);
imp_matrixl=full(imp_matrix1 ); imp_matrix2=imp_matrix1 ;
end
%% Calculate initial voltages on the surface coming from source at (0,xs)
% lower part at x=0
ds=sqrt((xter-xs).^2+zz.^2); inc_magx0=exp(- 1i*k0*ds)./sqrt(k0*ds);
% upper part at x=a
ds=sqrt((a-xs)^2+zz.^2); inc_magxa=exp(-1i*k0*ds)./sqrt(k0*ds);
V_incl=-inc_magx0; V_inc2=-inc_magxa;
%% Calculate currents on each segment
ind_currentl=imp_matrix1\V_incl.'; ind_current2=imp_matrix2\V_inc2.'


%% Calculate scattering ?elds
zobs = (0.5:Nz-0.5)*dz;
scat_mag=zeros( 1 ,Nz); sx0=zeros( 1 ,Nz); sxa=zeros(l ,Nz);
for m=l :Nz
% lower part contribution for observer range
scat_mag=scat_mag+findscatld(ind_currentl (m),k0,zobs,xo-xter(m),zz(m),pol);
% upper part contribution for observer range
scat_mag=scat_mag+findscatld(ind_current2(m),k0,zobs,a-xo,zz(m),pol);
% ?eld on each segment
sx0=sx0+findscatfld(ind_current2(m),k0,zobs,a-xter,zz(m),pol);
sxa=sxa+findscatfld(ind_current1(m),k0,zobs,a-xter(m),zz(m),p0l);
end
if pol==l ,
scat_mag = 0.25*dz* 1i*k0*scat_mag; % scattering ?elds on x=xobs
sx0 = 0.25*dz*li*k0*sx0; % scattering ?elds on x=0
sxa = 0.25*dz*li*k0*sxa; % scattering ?elds on x=b
else
scat_mag = -0.25*dz* l20*pi*k0*scat_mag; % scattering ?elds on x=xobs
sx0 = -0.25*dz*l20*pi*k0*sx0; % scattering ?elds on x=0
sxa = -0.25*dz*l20*pi*k0*sxa; % scattering ?elds on x=b
end
for m=l znumitr
[newscat_mag,sx0,sxa]=findmomscatfld(sx0,sxa,imp_matrix1 ,imp_matrix2,Nz,k0,zobs,a,xo,zz,dz,pol,xter);
scat_mag=scat_mag+newscat_mag; % sum all contributions
end
dist=sqrt((xo-xs)^2+zobs.^2);
inc_mag=exp(-1i*k0*dist)./sqrt(k0*dist); % if the source is an isotropic radiatorll
tot_hor=inc_mag+scat_mag;
output.xx=xx; output.zz=zz;
if pol==l , % TMz (ver)
t0t_h 0r=(EO/ 1 20*pi)*t0t_h or;
elseif pol==0, % TEZ (hor)
tot_hor=E0*tot_hor;
end
output.Fh1=tot_hor;
function scat_mag=findscatfld(ind_current,k0,zobs,xobs,zs,pol)
dd=sqrt(xobs.^2+(zobs-zs).^2);
if pol==l , % TMz (ver)
prinner=abs(xobs)./dd;
scat_mag=ind_current.*besselh( l ,2,k0*dd).*prinner;
elseif pol==0 % TEz (hor)
scat_mag=ind_current.*besselh(0,2,k0*dd);
end

function
[scat_mag,sx0,sxa]=findmomscatfld(sx0,sxa,imp_matrix1 ,imp_matrix2,Nz,k0,zobs,a,xobs,zs,deIz,pol,xter)
% Calculate new voltages on each segment
V_incl=-sx0; V_inc2=-sxa;
% Calculate new currents on each segment
ind_current1 =imp_matrixl\V_incl .';% tran spose( V_inc)
ind_current2=imp_matrix2\V_inc2.';% transpose(V_inc)

% Calculate new scattering ?elds
scat_mag=zeros(l,Nz); sxa=zeros(l,Nz); sx0=zeros(l ,Nz);
for m=l :Nz
% lower part contribution for observer range
scat_mag=scat_mag+findscatfld(ind_current1(m),k0,zobs,xobs-xter(m),zs(m),pol);
% upper part contribution for obsewer range
scat_mag=scat_mag+findscatfld(ind_current2(m),k0,zobs,a-xobs,zs(m),pol);
% ?eld on each segment
sxa=sxa+flndscatfld(ind_currentl(m),k0,zobs,a-xter(m),zs(m),pol);
sx0=sx0+flndscatfld(ind_current2(m),k0,zobs,a-xter,zs(m),p0I);
end
if pol==l
scat_mag=0.25*delz*li*k0*scat_mag; % scattering ?elds on x=xobs
sx0=0.25*delz*li*k0*sx0; % scattering ?elds on x=0
sxa=0.25*delz*li*k0*sxa; % scattering ?elds on x=b
elseif pol==0
scat_mag=-0.25*delz* l20*pi*k0*scat_mag; % scattering ?elds on x=xobs
sx0=-0.25*delz*l20*pi*k0*sx0; % scattering ?elds on x=0
sxa=-0.25*delz* l20*pi*k0*sxa; % scattering ?elds on x=b
end


