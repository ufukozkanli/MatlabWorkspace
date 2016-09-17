function output=imageraysummation(E0,fr,a,zmax,xs,zo,xo,NX,NZ,pol)
% Ray Summation with image method inside a 2D-PEC parallel plate waveguide
% for the calculation of
% Field vs Range at a given height (xo)
% Field vs Height at a given range (zo)
%
% E0: Field amplitude
% fr: frequency [MHZ], a: plate height [m], zmax: maximum range [m]
% xs: source height [m], zo: observer range [m], xo: observer height [m]
% NX: number of height points, NZ: number of range points
% pol: polarization type, 0 for TEz case, 1 for TMz case
%
% output.zz: range points
% output.xx: height points
% output.fx0: vertical ?eld at z=0
% output.fx: vertical ?eld at z=zo
% output.fz: horizontal ?eld at x=xo
%--------------------------------_-_------_----_--_--------_----_-------_--
k0=2*pi*fr/300; % wavenumber in free space
xx=(0:a/(NX-l):a).';
zz=(0:zmax/(NZ-l):zmax).'; zz=0.5*(zz(l :end-l)+zz(2:end));
Fv0=zeros(NX, 1); Fvl =zeros(NX, 1); Fh1 =zeros(length(zz), 1 );
% Field vs Height at z=0 and z=zo
for ii=0:zo:zo
Fvfree=rayfld(k0,ii,xx,xs);
Fvpl=rayfld(k0,ii,xx,-xs); Fvp2=rayfld(k0,ii,xx,2*a-xs);
if pol==0,
Fvtot=Fvfree-Fvp1 -Fvp2;
elseif pol==1,
Fvtot=Fvfree+Fvpl +Fvp2;
end

ind=l ; ep=sum(abs(Fvp1+Fvp2))/ 1e3;
while sum(abs(Fvpl+Fvp2))>ep, ind=ind+l;
Fvpl=rayfld(k0,ii,xx,(-1)^ind*xs+2*ceil(ind/2)*a);
Fvp2=rayfld(k0,ii,xx,(- 1)^ind*xs-2*floor(ind/2)*a);
if pol==0,
Fvt0t=Fvtot+(- 1 )^ind*(Fvp1 +Fvp2);
elseif pol==l,
Fvtot=Fvtot+Fvpl +Fvp2;
end
if ind==1000, display('Max iter.( 1 000) reached!');Fvpl=0;Fvp2=0;end
end
if pol==0, Fv=E0*Fvtot; elseif pol==l, Fv=E0/(l20*pi)*Fvtot; end
if ii==0, Fv0=Fv; else Fvl=Fv; end
end
% Field vs Range at x=x0
Fhfree=rayfld(k0,zz,xo,xs);
Fhpl=rayfld(k0,zz,x0,-xs); Fhp2=rayfld(k0,zz,xo,2*a-xs);
if pol==0,
Fht0t=Fhfree-Fhpl -Fhp2;
elseif pol==l,
Fht0t=Fhfree+Fhp1+Fhp2;
ind= 1; ep=sum(abs(Fhp1 +Fhp2))/ le3;
while sum(abs(Fhpl+Fhp2))>ep, ind=ind+ 1;
Fhpl =rayfld(k0,zz,xo,(- 1 )^ind*xs+2*ceil(ind/2)*a);
Fhp2=rayfld(k0,zz,x0,(- l )^ind*xs-2*floor(ind/2)*a);
if pol==0,
Fhtot=Fhtot+(- l)^ind*(Fhp1+Fhp2);
elseif pol==l ,
Fhtot=Fhtot+Fhp1 +Fhp2;
end
if ind==l000, display('Max iter.( 1000) reached!');Fhpl=0;Fhp2=0;end
end
if pol==0, Fhl=E0*Fhtot; elseif pol==l, Fhl=E0/(l20*pi)*Fhtot; end
% Results
output.xx=xx; output.zz=zz;
output.Fv0=Fv0; output.Fv1=Fvl ; output.Fhl=Fh1 ;

function F=rayfld(k0,zo,x0,xs)
R=sqrt(z0.^2+(x0-xs).^2);
F=exp(-1i*k0*R)./sqrt(k0*R);



