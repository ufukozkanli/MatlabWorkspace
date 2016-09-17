function main
output=modesummation(4*10^-4,75/pi,1,2,0.3,0,0.7,100,100,100,0)

function output=modesummation(E0,fr,a,zmax,xs,zo,xo,NX,NZ,mm,pol)
%% Mode Summation inside a 2D-PEC parallel plate waveguide
% for the calculation of
% Field vs Range at a given height (xo)
% Field vs Height at a given range (zo)
%
% E0: Field amplitude
% fr: frequency [MHz], a: plate height [m], zmax: maximum range [m]
% xs: source height [m], zo: observer range [m], xo: observer height [m]
% NX: number of height points, NZ: number of range points, mm: mode number
% pol: polarization type, 0 for TEz case, 1 for TMz case
%
% output.zz: range points
% output.xx: height points
% output.fx0: vertical ?eld at z=0
% output.fx: vertical ?eld at z=zo
% output.fz: horizontal ?eld at x=xo
%--------------------------------------------------------------------------
k0=2*pi*fr/300; % wavenumber in free space
kz=conj(sqrt(k0^2-((1 :mm)*pi/a).^2));
xx=(0:a/(NX-1):a).';
zz=(0:zmax/(NZ-1):zmax).'; zz=0.5 *(zz(1 :end- 1 )+zz(2 :end));
if pol==0 % TEz case
    funTE=@(MM,XX,KZ,ZZ) 2/a*sum(sind(180*MM*xs/a).*sind(180*MM.*XX/a)...
        .*exp(-1i*KZ.*ZZ)./(2*1i*KZ));
    % Field vs Height
    [~,MM]=meshgrid(xx,1 :mm); [XX,KZ]=meshgrid(xx,kz);
    Fv0=funTE(MM,XX,KZ,0); % at z=0
    Fvl=funTE(MM,XX,KZ,zo); % at z=zo
    % Field vs Range
    [~,MM]=meshgrid(zz,1 :mm); [ZZ,KZ]=meshgrid(zz,kz);
    Fhl=funTE(MM,xo,KZ,ZZ).'; % at x=xo
    Fv0=E0*Fv0; Fv1=E0*Fvl; Fhl=E0*Fhl;
elseif pol==l % TMz case
    funTM=@(MM,XX,KZ,ZZ) 2/a*sum(cosd(l80*MM*xs/a).*cosd(180*MM.*XX/a)...
        .*exp(-1i*KZ.*ZZ)./(2* 1i*KZ));
    % Field vs Height
    [~,MM]=meshgrid(xx,l :mm); [XX,KZ]=meshgrid(xx,kz);
    Fv0=funTM(MM,XX,KZ,0)+l/a*exp(-1i*k0*0)/(2* li*k0); % at z=0
    Fv1=funTM(MM,XX,KZ,zo)+l/a*exp(-li*k0*zo)/(2*li*k0); % at z=zo
    % Field vs Range
    [~,MM]=meshgrid(zz, l :mm); [ZZ,KZ]=meshgrid(zz,kz);
    Fh1 =funTM(MM,xo,KZ,ZZ).'+1/a*exp(-1i*k0*zz)/(2*1i*k0); % at x=x0
    Fv0=E0/(l20*pi)*Fv0; Fv1=E0/(l20*pi)*Fvl; Fh1=E0/(120*pi)*Fhl ;
end
% Results
output.xx=xx; output.zz=zz;
output.Fv0=Fv0.'; output.Fv1=Fvl.'; output.Fh1 =Fhl .';

plot(output.Fv0(1:99),output.Fh1(1:99))
