
function [xx1,yy1,beam1,is_inf] = mirr_beam(xx0,yy0,beam0)

% MIRR_BEAM  Calculation of BeamPaths
%
% required by MIRR_DRAW
%             mirr_cb, mirr_move
%             mirror
%
% [x1,y1,beam1,Is_Inf] = MIRR_BEAM(x0,y0,beam0)
%
%  where are [x0 ; y0] Points on the incoming Beam with
%                       the DirectionVector beam0
%   and  [x1 ; y1] Points on the Mirror of the outgoing Beam 
%   with the DirectionVector beam1.
%  ( one Beam per Column ! )
%
%  The Beams, which don't meet the Mirror, gets the DummyValue
%   from MC(4,5) (about 9999). Is_Inf  contains the Index of
%   this Beams.
%



global MC

more off

 Accuracy = 1e-9;  % for x-Values on ReflectionPoints
 

    xx0 =   xx0 .* [ abs(  xx0) > 2*Accuracy ];
    yy0 =   yy0 .* [ abs(  yy0) > 2*Accuracy ];
  beam0 = beam0 .* [ abs(beam0) > 2*Accuracy ];


  % Line of Beam

  % find Vertical Beams  Slope --> Inf
            is_vert  = find( abs(beam0(1,:)) < Accuracy );
    beam0(1,is_vert) = nan*is_vert;

  % Line of Beam
  m0 = beam0(2,:)./beam0(1,:);

  % find Horizontal Beams  Slope --> 0
            is_hori  = find( abs(beam0(2,:)) < Accuracy  | ...
                             ( m0.^2 + MC(2,4)-1 ) == 0     );
                              % See later Calculation of "p"
  % Line of Beam
  m0(is_hori) = 0*is_hori;

  n0 = yy0 - m0.*xx0;

    beam0(1,is_vert) = 0*is_vert;


% save mirr1

 %********************************************************
 % Find Points(xx1,yy1) of Intersection with Mirror


  % Square Equation  0 = xx.^2 + p*xx + q

    m0(is_hori) = nan*is_hori;

  p = 2*( m0.*n0 - 2*MC(2,3) - MC(5,3)*(MC(2,4)-1) ) ./ ...
        ( m0.^2 + MC(2,4)-1 ) ; 
        
  q =   ( n0.^2 + 4*MC(2,3)*MC(5,3) + MC(5,3)^2*(MC(2,4)-1) ) ./ ...
        ( m0.^2 + MC(2,4)-1 ) ;

  xx1 =  [ -p/2 + sqrt(p.^2/4-q) ; ...
           -p/2 - sqrt(p.^2/4-q)      ];  % 2 Results
 
    m0(is_hori) = 0*is_hori;


  % BAD Results
  bad = [ imag(xx1) ~= 0  ];


  if ~isempty(is_hori)
 
   % X-Result for Horizontal Beams
   xxh = [ [ yy0(1,is_hori).^2 / (4*MC(2,3)) ] ; ...
           [ -sqrt( 4*MC(2,3)^2 - yy0(1,is_hori).^2 ) + ... 
             2*MC(2,3) ] ] + MC(5,3) ;

   xxh     = xxh(MC(2,4),:);

       kk  = find( abs(xxh-xx0(1,is_hori)) < 50*Accuracy );
   xxh(kk) = nan*kk;   % Set bad Results NaN

   xx1(1,is_hori) = xxh;


   % Refresh BAD
   if ~isempty(kk)
    bad(1,is_hori(kk)) = 1+0*kk;
   end
    bad(2,is_hori) = 1+0*is_hori;
 
  end
  % is_empty  

 
  % X-Result for Vertical Beams 
  xx1(:,is_vert)  = xx0([1 1],is_vert);




  % xx-Result in xlim of Mirror
  bad = [ bad  |  [ xx1 < MC(5,3)  |  MC(5,3)+MC(5,2) < xx1 ] ];


  % Set BAD Results to NaN
  xx1(find(bad)) = nan*find(bad);

 
  % Y-Results
  yy1 = [ m0 ; m0 ] .* xx1 + [ n0 ; n0 ];



  if ~isempty(is_vert)

   is_nan = isnan(yy1);

   % Y-Result for vertical Beams
   yyv = [ sqrt(4*MC(2,3)*(xx1(1,is_vert)-MC(5,3))) ; ...
           sqrt( 4*MC(2,3).^2 -                       ...
                (xx1(1,is_vert)-MC(5,3)-2*MC(2,3)).^2 ) ];

   yyv     = [ -1 ; 1 ] * yyv(MC(2,4),:);

       kk  = find( abs(yyv-yy0([1 1],is_vert)) < 50*Accuracy );
   yyv(kk) = nan*kk;  % Set bad Results NaN

   yy1(:,is_vert) = yyv;


   % Refresh BAD
   new_nan = [ isnan(yy1) & xor( isnan(yy1) , is_nan ) ];
       bad = [ bad  |  [ new_nan & xor( new_nan , bad ) ] ];
 
  end
  % isempty


  % yy-Result in ylim of Mirror 
  bad = [ bad  |  [ yy1 < -MC(5,4)  |  MC(5,4) < yy1 ] ];


  % Find the equal Points 
  x_diff =  abs(xx1-xx0([1 1],:)) ;
  y_diff =  abs(yy1-yy0([1 1],:)) ;  
  bad = [ bad  | ...
         [ [ x_diff < 1e2*Accuracy | y_diff < 1e2*Accuracy ] &  ...
           [ x_diff < 1e3*Accuracy & y_diff < 1e3*Accuracy ] ] ];


  % Direction compared to MagDirection

  bad = [ bad  | [ [(xx1-xx0([1 1],:)).*beam0([1 1],:) + ... 
                    (yy1-yy0([1 1],:)).*beam0([2 2],:)] < 0 ] ];

 

  % Distance to Mag, to take only the nearest Point
  
  dd = (xx1-xx0([1 1],:)).^2 + (yy1-yy0([1 1],:)).^2;
  
     is_inf  = find( bad | isnan(dd) );
  dd(is_inf) = 1e10+0*is_inf;


  bad = [ bad  |  [ dd ./ [ max(dd) ; max(dd) ] == 1 ] ];



  is_bad = find(bad);

  xx1(is_bad) = 0*is_bad;
  yy1(is_bad) = 0*is_bad;

  xx1         = sum(xx1);
  yy1         = sum(yy1);

      is_nan  = find( sum(bad) == 2 );
  xx1(is_nan) = nan*is_nan;
  yy1(is_nan) = nan*is_nan;




 %***********************************************************
 % Now find the Reflected Beam
  

  % Slope of Tangente in Intersection Point

  xx11 = xx1 + Accuracy*[ abs(xx1-MC(5,3)) < Accuracy];

  m_nn = sign(yy1([1 1],:)) .* [ ...
         [ sqrt( MC(2,3) ./ (xx11-MC(5,3)) )  ] ; ...
        -[(xx1-MC(5,3)-2*MC(2,3)) ./ ...
           sqrt( 4*MC(2,3)^2 - (xx11-MC(5,3)-2*MC(2,3)).^2 ) ]      ];

  m_nn = m_nn(MC(2,4),:);

  % TangentVector
  nn = [ ones(size(m_nn)) ; m_nn ];
  nn = nn ./ [ ones(2,1) * sqrt(sum(nn.^2)) ]; 

  % Normale of Tangente
  m_nn = -1./(m_nn+1e-10*[m_nn==0]);
  n_nn = yy1 - m_nn.*xx1 ;

 
  % LotVector  cc0 -->  Normale of Tangente 
  
   d = ( yy0 - (m_nn.*xx0+n_nn) ) ./ ...
       ( m_nn.*nn(1,:) - nn(2,:) );

   d = d .* [ abs(xx1-MC(5,3)) > Accuracy ];

 
  % Point on the new beam
  % xx3 = xx0 + 2*dd.*nn(1,:);
  % yy3 = yy0 + 2*dd.*nn(2,:);
   
  % new Beam
 
  beam1 = [ xx0 + 2*d.*nn(1,:)  -  xx1 ; ...
            yy0 + 2*d.*nn(2,:)  -  yy1       ];
  beam1 = beam1 ./ [ ones(2,1) * sqrt(sum(beam1.^2)) ]; 



     is_inf  = [ isinf(yy1) | isnan(yy1) ];
 
   find_inf  = find(is_inf);

%  save mirr2
  
    % Normale of Tangente

     nn = [ ones(size(m_nn)) ; m_nn ];

     cos_alpha = sum(beam0 .* nn );  
     % < 0  inner;  > 0 outher
 
     xx1 = xx1 + (-sign(cos_alpha))*5*Accuracy;


  xx1(find_inf) = xx0(1,find_inf) + MC(4,5) * beam0(1,find_inf) ;
  yy1(find_inf) = yy0(1,find_inf) + MC(4,5) * beam0(2,find_inf) ;  



more on