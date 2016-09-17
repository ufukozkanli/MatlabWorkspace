function mirr_cntr(xlim,ylim,MirrorXMax2)

% MIRR_CNTR  Create MirrorControlWindow
%
% requires MIRR_CB for UIControlCallbacks
%
% required by MIRROR
%
% The Handles of the UIControl's are stored in 
%  the global Variables HMC0 and HMC1 (Slider)
%  The Arrangement in this Variables corresponds 
%   the Arrangement of the UIControl's in the ControlWindow.
%
% The global Variable HHMC contains the UIControlHandles too,
%  but here the Arrangement corresponds with the global
%   ParameterControlVariable MC .
% 

global MC  HHMC  HMC0  HMC1


% HandleMirrorControl  HMC0



%**************************************************************
%
% Define UIControls in an Array as seen on Screen
%

%--------------------------------------------------------------
% UIStyles

types = [ 'text' ; ...
          'edit' ; ...
          'popu' ; ...
          'chec' ; ...
          'push'       ]; 


tt = [  1    1  NaN    5
        3    2    2    2
        2    2    2    2 
        3    2    2    4   ];  % RowIndex for  "types"




%--------------------------------------------------------------
% Min, Max  for Sliders

xlim1 = xlim + [-1  1]*diff(xlim)/2;
ylim1 = ylim + [-1  1]*diff(ylim)/2;

mmin = [    NaN      NaN    NaN  NaN
            NaN      0.1    0.01  0.01
       xlim1(1)  ylim1(1)  -180    1 
            NaN        0      0  NaN   ];

mmax = [    NaN      NaN    NaN  NaN
            NaN  xlim(2)-MC(5,3) 100  100
       xlim1(2)  ylim1(2)   180  100 
            NaN       20    180  NaN   ];




%--------------------------------------------------------------
% Labels or UIStrings

strings = ['X          ' ; ...
           'Y          ' ; ...
           'Rotation   ' ; ...
           'Number     ' ; ...
           'Scattering ' ; ...
           'Shadow     ' ; ...
           'Focus      ' ; ...
           'Hide       ' ; ...
           'Size       ' ; ...
           'Width      '       ]; 

ss = [   1    2  NaN    8 
       NaN    7    9   10
         1    2    3    9 
       NaN    4    5    6  ];  % RowIndex for "strings"




%-----------------------------------------------------------
% Index in MirrorControlVariable MC

MCii = [1:4]' * ones(1,size(tt,2));   % RowIndex for "MC"

MCii(2,3:4) = [ 5  5 ];  % MirrorSize & Width

MCjj = [ NaN  NaN  NaN  NaN
           4    3    2    1
           2    3    4    5
           4    2    3  NaN      ]; % ColumnIndex for "MC"


% Action for MIRR_DRAW
% in MIRR_CB: mirr_draw(kinds(MCii,:))

kinds = ['    ' ; ...
         'mirr' ; ...
         'magl' ; ...
         'beam' ; ...
         'mirr'         ]; 


%--------------------------------------------------------------
% PopUpMenu's

popup_strings = [ 'Parabol' ; ...
                  'Sphere ' ; ...
                  'Flood  ' ; ...
                  'Spot   ' ; ...
                  'Bar    '      ];
popup_kenn = [ 1 
               1
               2
               2
               2  ];              % RowIndex for "popup_strings"

popup_kk = [  NaN  NaN  NaN  NaN
                1  NaN  NaN  NaN
              NaN  NaN  NaN  NaN 
                2  NaN  NaN  NaN   ];  % Value of "popup_kenn"



%--------------------------------------------------------------
% Labels for UIGroups

names = [ 'Pointer ' ;  ...
          'Mirror  ' ; ...
          'MagLight' ;  ... 
          'Beam    '         ];


%--------------------------------------------------------------
% Positioning

ww = 80;  % Width
hh = 30;  % Hight
hd = 20;  % horiz.Distance
vd = 40;  % vert. Distance

x0 = 100; % Left Space for GroupLabels





[M,N] = size(tt);

%--------------------------------------------------------------
% Global Handles

HMC0 = nan*ones(M,N);
HMC1 = nan*ones(M,N);       % Slider
HHMC = nan*ones(size(MC));  % Handles for MC
HT   = nan*ones(M,N);       % LabelTextHandels


%***************************************************************
%
% START
%


scr_si = get(0,'screensize');

fig_width  = x0    + N * (ww+hd) + hd; % ControlButton withSpace
fig_height = vd-10 + M * (hh+vd);

figpos = [ scr_si(3)-fig_width-100  50  fig_width  fig_height ];


v = version;
if v(1) == '4'
 property  = 'nextplot';
 propvalue = 'add';
 vs = 's';
else
 property  = 'handlevisibility';
 propvalue = 'callback';
 vs = '';
 set(0,'defaultuicontrolfontsize',12)
end

scr_si = get(0,'screensize');

MC(6,1) = figure('position',figpos, ...
            'color',[1 1 1], ...
            property,propvalue , ...
            'numbertitle','off', ...
            'menubar' , 'none' , ...
            'visible','off', ...
            'tag','Mirror' , ...
            'name', 'Mirror - Control');



MC(6,2) = axes('parent',MC(6,1) , ...
     'position',[0 0 1 1], ...
     'visible','off'     , ...
     'xlim'   , [0 figpos(3)] , ...
     'ylim'   , [0 figpos(4)]        );

set(MC(6,2),'units','pixel', ...
            'nextplot','add'    );




for ii = 1 : M

 for jj = 1 : N

  if ~isnan(tt(ii,jj))

   typ = deblank(types(tt(ii,jj),:));

   str = '';
   if ~isnan(ss(ii,jj))
    str = deblank(strings(ss(ii,jj),:));
   end

   ui_str = ' ';
   if strcmp(typ(1:4),'popu')
          kk = find( popup_kenn == popup_kk(ii,jj) );  
      ui_str = popup_strings(kk,:);
   elseif strcmp(typ(1:4),'push') | strcmp(typ(1:4),'chec')
      ui_str = str;  str = '';
   end

   is_edit = strcmp( typ , 'edit' );

   val = 0;
   if ~isnan(MCjj(ii,jj))
    val = MC(MCii(ii,jj),MCjj(ii,jj));
   end

   % Store TextFormat in 'userdata'
   form = '%6.1f';
   if all( [ii jj] == [4 2] ) | ...
      all( [ii jj] == [3 4] ) 
    % Number of Beams, Size
    form = '%3.0f';
   elseif ii == 2 & any(jj==[3 4])
    % Size Width
    form = '%6.2f';
   elseif all( [ii jj] == [2 1] ) 
    % MirrorType-PopUpMenu
    % Store MirrorXMax of other MirrorType in 'userdata'
    %      [ MirrorXMax2  MirrorSizeMax2    ]    
    %form = [ MirrorXMax2  si_max(3-MC(2,4)) ]; 
   end


   CB = [ 'mirr_cb(''' typ            ''','   ...
                   int2str(ii)          ','   ...
                   int2str(jj)          ','   ...
                   int2str(MCii(ii,jj)) ','   ...
                   int2str(MCjj(ii,jj)) ',''' ...
        deblank(kinds(MCii(ii,jj),:)) ''')'        ];


  
   xpos = (jj-1)*(hd+ww)+x0 + hd*strcmp(typ(1:4),'push');
   ypos = (M-ii)*(vd+hh)+vd-10 + ...
          10 * [ is_edit | strcmp(typ,'text') | ...
                           strcmp(typ(1:4),'push') ];


   HMC0(ii,jj) = uicontrol( ...
    'parent'   , MC(6,1) , ...
    'position' , [ xpos ypos ww ...
                   hh-10*[ is_edit | strcmp(typ,'text') ] ] , ...
    'style'    , typ , ...
    'string'   , ui_str , ...       
    'value'    , val , ...
    'userdata' , form , ...
    'callback' , CB , ...
    'backgroundcolor',[0.8 0.9 1.0] - ...
                      [0.1 0.2 0.1] * strcmp(typ(1:4),'push') );

   if is_edit
     CB = [ 'mirr_cb(''slider'','               ...
                     int2str(ii)          ','   ...
                     int2str(jj)          ','   ...
                     int2str(MCii(ii,jj)) ','   ...
                     int2str(MCjj(ii,jj)) ',''' ...
          deblank(kinds(MCii(ii,jj),:)) ''')'        ];

    HMC1(ii,jj) = uicontrol( ...
    'parent'  , MC(6,1) , ...
    'position',[ xpos ypos-10 ww 10 ] , ...
    'style'   , 'slider', ...
    'min'     , mmin(ii,jj) , ...
    'max'     , mmax(ii,jj) , ...
    'value'   , val , ...
    'callback', CB , ...
    'backgroundcolor',[0.8 0.9 1.0] - 0.1 );

    HHMC(MCii(ii,jj),MCjj(ii,jj)) = HMC1(ii,jj);

   end    

   if ~isempty(str)
    HT(ii,jj) = text( xpos+ww/2 , ...
           ypos+hh-10*[ is_edit | strcmp(typ,'text') ] , ...
           str , ...
                'parent',MC(6,2) , ...
                'color'               , [0 0 0]  , ...
                'units'               , 'pixels' , ...
                'fontsize'            , 12       , ...
                'fontweight'          , 'bold'   , ...
                'horizontalalignment' , 'center' , ...
                'verticalalignment'   , 'bottom'         );      
   end            

  end
 end
 % jj


     ypos = ypos - 10*is_edit;

     text( 10 , ypos+hh/2 , deblank(names(ii,:)) , ...
                'parent',MC(6,2) , ...
                'color'               , [0 0 0]  , ...
                'units'               , 'pixels' , ...
                'fontsize'            , 14       , ...
                'fontweight'          , 'bold'   , ...
                'horizontalalignment' , 'left' , ...
                'verticalalignment'   , 'middle'         )      

end
% ii




% Size depends from Focus
form = get(HMC0(2,3),'userdata');

SizeMaxFormula = ['sprintf(''[' form ' ' form ']'',' ...
                  ' [ 100+100*exp(-MC(2,3)/50) ; ' ...
                  ' (2*MC(2,3)-0.01)  ])' ];  

si_max = eval(eval(SizeMaxFormula));


% Store SizeMaxFormula in MirrorSizeSliderUserData
%   HMC1(2,3)
set(HHMC(5,2),'max',si_max(MC(2,4)) , ...
              'userdata',SizeMaxFormula)



% MirrorType-PopUpMenu
% Store MirrorXMax of other MirrorType in 'userdata'
%      [ MirrorXMax2  MirrorSizeMax2    ]    

set(HMC0(2,1),'userdata',[ MirrorXMax2  si_max(3-MC(2,4)) ])




for ii = 1 : M
 for jj = 1 : N
   if ~isnan(HMC1(ii,jj))

     eval( get(HMC1(ii,jj),'callback') )
   end
 end
end

v = version;
if v(1) == '4'
set(MC(6,1),'nextplot','replace')
end
