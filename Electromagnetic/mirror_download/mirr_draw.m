
function mirr_draw(action)

% MIRR_DRAW  Draws MirrorObject, MagLightObject, Beams
%
%  requires MIRR_BEAM for Calculation of BeamPath 
%
%  required by  mirr_move
%               mirr_cb
%               mirror
% 

global MC



% Colors

 gold = [ 255  215    0 ] / 255;  % Gold #ffd700
 red  = [ 250   19   64 ] / 255;  % Red  #fa1340




% Basics for Mag
%  used in 'mag' AND 'beam'
       
      Tw = 1;       % TopWidth == 1   *** !!! ***
      Bw = 0.48;    % BaseWidth

      Ll = 4.2;     % Length

      ee = 3.0;       % Exponent
      aa = 12;     % outher ParableFactor

    % x = Size * aa*yy^ee;  yy = [ -Tw/2 .. +Tw/2 ]
    %
    % Size = MC(3,5)
  

if strcmp(lower(action),'mirr')

  
   xl = get(MC(1,2),'xlim');


   nn   = 100;             % Teilung eines Halbbogen

   bff = 0.5;                   % BasisWidth = bff*Focus for
                                %       Focus --> 0  
                                % BasisWidth MC(5,1)       for 
                                %       Focus --> infinite
                                % Basiswidth = 1 for
                                %  Focus --> 0, MC(5,1) --> 100
                                % Basiswidth = 0 for
                                %  MC(5,1) --> 0
                                
                                   
%   bww = - MC(5,1) * ( -1./(bff/MC(5,1) * MC(2,3) + 1) + 1 );
%   bww = - MC(5,1) * ( -1./(bff/4 * MC(2,3) + 1) + 1 );
  
  bww = -  ( MC(5,1) * [MC(5,1)>0.1] ) * ...
           ( -1./(bff/MC(5,1) * MC(2,3) + 100/99) + 1 );
  
   bee = 1 + 0.1*(1-exp(-abs(bww)));  % Exponent for Backline
 
   x = MC(5,2) * flipud( linspace( 0 , 1 , nn )' ) .^ 2 ;
                 
   y = [ sqrt(4*MC(2,3)*x) , ...
         sqrt( 4*MC(2,3).^2 - (x-2*MC(2,3)).^2 ) ];
   y = y(:,MC(2,4));

   x = [ x  ;  flipud(x(1:nn-1)  ) ];
   y = [ y  ; -flipud(y(1:nn-1,:)) ];

   % BackLine
   if MC(5,5)
    xb = flipud( x - bww/x(1) * abs(x) + bww ); 
    xb = ( (xb-bww)/(MC(5,3)+MC(5,2)-bww) ).^bee * ...
         (MC(5,3)+MC(5,2)-bww) + bww;
    yb = flipud(y);
   else
    % Norm
    nxy = [ sqrt(x/MC(2,3)) , ...
            sqrt(4*MC(2,3)^2 ./ (x-2*MC(2,3)).^2 -1 ) ];

    nxy = [ -ones(size(x))  sign(y).*nxy(:,MC(2,4)) ] ;
    nxy = nxy ./ [sqrt(sum(nxy'.^2))'*ones(1,2)];
 

    xb = flipud( x - bww*nxy(:,1) );
    yb = flipud( y - bww*nxy(:,2) ); 
   end
 
   % Set MirrorYMax, we need this in MIRR_BEAM

   MC(5,4) = y(1);




  if isnan(MC(2,1))
  %  create new  Parable


   % MiddleLine over the Screen

   Line = plot([0 10*max(get(MC(1,2),'xlim'))], ...
               [0  0],'w--');



   % Corpus of Mirror

   MC(2,1) = patch( ...
     [x;xb]+MC(5,3) , [y;yb] , [1 1 1] , ...
     'edgecolor','none', ...
     'erasemode' , 'background' , ...
     'linewidth',1+[bww==0] , ...
     'clipping','off', ...
     'parent', MC(1,2) , ...
     'tag','mirror'           );



   % 1 Point on each Edge to  Change the Size 
 
   Hedge = plot(x([1 2*nn-1])+MC(5,3),y([1 2*nn-1]),'.', ...
      'color',[1 1 1], ...
      'erasemode' , 'background' , ...
      'markersize',4 , ...
      'clipping','off', ...
      'parent', MC(1,2) , ...
      'tag','edge'    , ...
      'buttondownfcn','mirr_move(''down'',''edge'')'       );



   % 1 Point on the left Border of the MirrorCorpus at
   %   the MiddleLine to change the Width of the Base
  
   Hbase = plot( xb([nn])+MC(5,3) , 0 , '.' , ...
      'color',[1 1 1], ...
      'erasemode' , 'background' , ...
      'markersize',8 , ...
      'clipping','off', ...
      'parent', MC(1,2) , ...
      'tag','base'    , ...
      'buttondownfcn','mirr_move(''down'',''base'')'       );


   % FocusPoint

   MC(2,2) = plot( MC(2,3)+MC(5,3) , 0 , '.' , ...
      'color',[1 1 1] , ...
      'markersize', 16 , ...
      'erasemode','xor' , ...
      'clipping','off' , ...
      'parent' , MC(1,2) , ...
      'userdata',[Hedge ; Hbase] , ...
      'tag' , 'focus' , ...
      'buttondownfcn','mirr_move(''down'',''focus'')'    );


 
  else

    set(MC(2,1), 'xdata', [ x  ;  xb ] + MC(5,3),...
                 'ydata', [ y  ;  yb ] )

    set(MC(2,2),'xdata', MC(2,3)  )  

    HH = get(MC(2,2),'userdata');

    set(HH(1),'xdata',x([1 2*nn-1])+MC(5,3) , ...
              'ydata',y([1 2*nn-1])             );
  
    set(HH(2),'xdata',xb(nn)+MC(5,3) )

  end


    mirr_draw('beam');


%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

elseif strcmp(lower(action),'magl')


  % Rotation for Mag
  
  phi = MC(3,4)*pi/180;
 
  T = [  cos(phi)    sin(phi)  ; ...
        -sin(phi)    cos(phi)        ];


    if isnan(MC(3,1))
    % create new MagLight
   
     if ~[MC(4,4) == 3]
     % Spot/Flood --> MagLighte

      % Parable
      yp = linspace(Bw,Tw,50)/2 ;
      xp = -aa*(yp.^ee-(Bw/2)^ee)   ;

       xpp =  [ min(xp) + Ll , ...
                     xp           , ...
                     fliplr(xp)   , ...  
                     min(xp) + Ll          ];

       ypp =  [ Bw/2      , ...
                     yp        , ...
                    -fliplr(yp), ...
                    -Bw/2             ];

       color = red;
     else
     % Bar
       
      xpp = [ -1  1  1 -1 ] * Bw/2;
      ypp = [ -1 -1  1  1 ] * Ll/2;
 
      color = gold.^2;
     end

      xyp = MC(3,5) * [ T * [ xpp ; ypp ] ]';
  
      MC(3,1) = patch(xyp(:,1)+MC(3,2),xyp(:,2)+MC(3,3), ...
                  color, ... 
                 'edgecolor','none' , ...
                 'parent',MC(1,2), ...
                 'userdata' ,  [ xpp ; ypp ] , ...
                 'erasemode','xor' , ...
                 'clipping','off' , ...
                 'tag','mag', ...
                'buttondownfcn','mirr_move(''down'',''magl'')');



   else

    xyp = MC(3,5) * [ T * get(MC(3,1),'userdata') ]';
 
    set(MC(3,1),'xdata',xyp(:,1)+MC(3,2), ...
                'ydata',xyp(:,2)+MC(3,3)       );

   end


    mirr_draw('beam');



%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

elseif strcmp(action,'beam')

  xx = NaN;
  yy = NaN;  

 if MC(4,2)
  % Number of Beam ~= 0

  % NumberOfBeam == 1  while  Scattering == 0
  NB = MC(4,2) + ( 1 - MC(4,2) )*[ MC(4,3) == 0 ];

  % Rotation for Mag
  
  phi = MC(3,4)*pi/180;
 
  T = [  cos(phi)    sin(phi)  ; ...
        -sin(phi)    cos(phi)        ];

    
  % RadiationAngles

  rad0 = ( linspace(-MC(4,3),MC(4,3),NB) / 2 * ...
          [ NB > 1 ] ) * pi/180 ;

  rad = rad0 * [ MC(4,4) == 1 ] + phi;
  % including Direction Phi of Mag
  % Spot/Bar:  rad = Phi;  ( MC(4,4) = [ 2  3 ] )

  % Vector of Line
 
  beam = [ -cos(rad) ;  sin(rad)  ];

 
 
  h0 = aa*((Tw/2)^ee-(Bw/2)^ee);   % Depth of MagReflector (Parable)
  
  h  = Tw/2 / ( tan(MC(4,3)/2*pi/180) + 1e-10 );  % Depth in Mag

  h = (h0-h) * [ h < h0 ] ;  % Distance from MagCentre

  % CentrePoint in Mag  
  cc = MC(3,5) * [ T * [ -h ; 0 ] ] +  MC(3,2:3)'; 

  xx0 =  -aa*((Tw/2)^ee-(Bw/2)^ee);
  xx0 = xx0 + (-Bw/2 - xx0) * [MC(4,4)==3]; % Bar

  yy0 = (h0-h).*tan(rad0);
  yy0 = yy0 + (Ll/2.2*linspace(-1,1,NB)-yy0) * [MC(4,4)==3]; % Bar

  % Points on Top of Mag
  cc0 = MC(3,5) * [ T *  [ xx0*ones(1,NB) ; yy0 ]  ] + ...
        MC(3,2:3)' * ones(1,NB); 


  
  Nmax = 50;   % Max. Number of Cycles (Beam's)   
  
  xx = nan*ones(Nmax+3,NB);
  yy = xx;

  xx(1,:) = cc0(1,:);
  yy(1,:) = cc0(2,:);

  is_inf  = [ isinf(xx(1,:)) | isnan(xx(1,:)) ];
 
% save last1

   ok = find( ~is_inf ) ;
    N = 1;                % Number of Cycles

   while ~isempty(ok)  &  N < Nmax+1

    [xx(N+1,ok),yy(N+1,ok),beam(:,ok),ok_inf] = ...
       mirr_beam(xx(N,ok),yy(N,ok),beam(:,ok));  

    is_inf(ok(find(ok_inf))) = 1+0*find(ok_inf);    
    ok = find( ~is_inf ) ;
     N = N+1;

   end      


  yy = reshape( yy(1:N+1,:) , (N+1)*NB , 1 );
  xx = reshape( xx(1:N+1,:) , (N+1)*NB , 1 );


 end
 % if NB


   % LineWidthControl
   %        NofBeam   LineWidth
   lc =  [      1        3.0     ; ...
                3        1.5     ; ...
               Inf       0.5             ];

   % Linewidth
   
   lw = lc(3,2) + ( lc(1,2)-lc(3,2) ) * ...
        exp( -NB / ...
            ( -lc(2,1)/log((lc(2,2)-lc(3,2))/ ...
                           (lc(1,2)-lc(3,2))  ) )     );
 
      
   if isnan(MC(4,1))
     
    MC(4,1) = plot(xx,yy,'-', ...
                 'color',gold.^(1/2) , ...
                 'linewidth', lw , ...
                 'parent',MC(1,2), ...
                 'erasemode','xor' , ...
                 'clipping','off' , ...
                 'tag','beam' );

   else
    set(MC(4,1),'xdata',xx, ...
                'ydata',yy, ...
                 'linewidth',lw )
   end                   
  

end



