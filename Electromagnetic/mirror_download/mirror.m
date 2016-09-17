function mirror

% MIRROR  Simulation of BeamPath's on a Parabolic or Spheric Mirror
%
% MIRROR opens a figure which shows a Flashlight, its beams and a Mirror.
%
% Drag the light with the pressed left MouseKey, 
% rotate it with the right MouseKey.
%
% Modify the mirror by draging its base, ends or the focuspoint.
%
% With the Menu <Control> you can open a figure to control 
% the parameters of the mirror and the light. 
%
% requires MIRR_CNTR, MIRR_CB
%          MIRR_MOVE, MIRR_DRAW, MIRR_BEAM
%          MIRR_PRIN, MIRR_PRCB
%          MIRR_ZOOM, MIRR_MSG
%
% The Handles of UIMenu's are stored in the UserData of the Figure.
%
% The ControlParameters are stored in the Global Variable MC
%
%  TYPE:   >> type mirror
% 
% to get more Informations about MC
%



%  MC    MirrorControlVariable, 6 by 5
%
%
%  MirrFig       MirrAxe     PointerX     PointerY    ButtonDownX
%
%
%  HandleMirror  HandleFocus Focus         <1/2>      ButtonDownY
%                                  parabolic/spheric
%
%  HandleMag     X0          Y0           Rotation    ScaleFactor
%
%
%  HandleBeam    NofBeam     ScatterAngle   <1/2/3>      InfDummy 
%                                         flood/spot/bar         
%
%  MirrBase      MirrorXMax  MirrorXMin   MirrorYMax       0/1
%                                                      Equal/Moon
%
%  ControlFig    ControlAxe  PrintFig   PrintUIMenu    QuitUIMenu
%
%
%
%
%  Rotation  Direction of Mag  (Horizontal, leftward:  Phi = 0 )
%
%  MirrorBaseWidth = MirrorBaseWidth(MirrorBase,Focus) = ...
%   - MirrorBase * ( -1./(0.5/MirrorBase * MC(2,3) + 1) + 1 )
%
%


%*************************************************
%
% Check if all required Files exist


files = [ ...

'mirror   ' ; ...
'mirr_cntr' ; ...
'mirr_cb  ' ; ...
'mirr_move' ; ...
'mirr_draw' ; ...
'mirr_beam' ; ...
'mirr_prin' ; ...
'mirr_prcb' ; ...
'mirr_zoom' ; ...
'mirr_msg '       ];


file_ok = ones(size(files,1),1);
for ii = 1:length(files(:,1))
  file_ok(ii) = exist(deblank(files(ii,:)));
end

        
if any( file_ok ~=  2 )

 % Any Files didn't exist !!!

 nf = 4;  % NumberOfFileNames,displayed per Row in MessageBox

 not_found = files(find(file_ok ~= 2),:);
 not_found = [ not_found 32*ones(size(not_found,1),6) ];
        si = size(not_found);
 not_found = [ not_found ;  32*ones( nf-rem(si(1),nf) , si(2) )];
        si = size(not_found);
 not_found = reshape(not_found',nf*si(2),size(not_found,1)/nf)';
 not_found = [ 32*ones(size(not_found,1),3) ,  ...
               not_found                    ,  ...
               meshgrid([13 10],not_found(:,1))    ];

 not_found = reshape( not_found' , 1 , prod(size(not_found)) );

 diag_name = 'Error';
 diag_txt = ['  Didn`t found following Requested M-Files ' ...
             'in Matlab`s SearchPath: ' ...
  setstr(13) setstr(10) setstr(13) setstr(10) ...
  setstr(not_found) ];

  dd=0;
  
   
    mirr_msg(  ...
    'position',[150+20*dd 300-20*dd 500 150] ,  ...
    'style'           , 'error'       ,  ...
    'Name'            , diag_name     , ...
    'BackgroundColor' , [1 1 1]       ,  ...
    'ButtonStrings'   , 'Ok'          ,  ...
    'ButtonCalls'     , 'delete(gcf)' ,  ...
    'ForegroundColor' , [0 0 0]       ,  ...
    'Replace'         , 'off'         ,  ...
    'TextString'      ,  ...
       [ setstr(13) setstr(10)  diag_txt ] ); 
 
      

else

%*********************************************************
% Start Program


% Close all MirrorFigures

figs = get(0,'children');
for fig = figs(:)'
 if strcmp(get(fig,'tag'),'Mirror')
  try
     delete(fig)                   % MirrorGrafik, Control, Print
  end
 end
end


global MC


MC  = [ ...

NaN   NaN   NaN    NaN   NaN  ; ...
NaN   NaN   NaN      1   NaN  ; ...
NaN   100    20      0    12  ; ...
NaN     3    30      2  9999  ; ...
  1   NaN     0    NaN     0  ; ...
NaN   NaN   NaN    NaN   NaN          ];


% default Focus

MC(2,3) = 10*MC(2,4);  % par:  10
                       % circ: 20


% default MirrorXMax

MC(5,2) = (-2.5*MC(2,4)+6.5)*MC(2,3); % par:  4  *f
                                      % circ: 1.5*f

% for other MirrorType
MirrorXMax2 = (-2.5*(3-MC(2,4))+6.5)*MC(2,3); 



xlim = [ -20  200 ];
ylim = diff(xlim)/2 * [ -1   1 ];

    
v = version;
if v(1) == '4'
property  = 'nextplot';
propvalue = 'add';
aspectprop1 = 'aspectratio';
aspectprop2 = aspectprop1;
aspectval  = [1 1];
vs = 's';
else
property  = 'handlevisibility';
propvalue = 'callback';
aspectprop1 = 'plotboxaspectratio';
aspectprop2 = 'dataaspectratio';
aspectval  = [1 1 1];
vs = '';
end

scr_si = get(0,'screensize');

ff = min(scr_si(3:4))-250;

MC(1,1) = figure( ...
            'position',[120 100 ff ff] , ...
            'color',[0 0 0], ...
            'inverthardcopy','on', ...
            'numbertitle','off', ...
            'menubar' , 'none' , ...
            'visible','on', ...
            'tag','Mirror' , ...
            'name', 'Mirror');



uilabels = ['Control' ; ...
            'Help   ' ; ...
            'Refresh' ; ...
            'Zoom on' ; ...
            'Print  ' ; ...
            'Quit   '         ];

childs = [ 0
           7
           0
           0
           0
           0  ];


m = zeros(1,7);

for ii = 1:size(uilabels,1)

  label = deblank(uilabels(ii,:));

  CB = [ 'mirr_cb(''' lower(label) ''',' int2str(ii) ','  ...
          int2str(childs(ii)) ',1,1,'''')' ];

 m(ii) = uimenu('accelerator',label(1), ...
        'parent',MC(1,1) , ...
        'label',label, ...
        'enable','off' , ...
        'callback',CB );

end




% HelpLabel
m(7) = uimenu('accelerator','', ...
       'parent',m(2) ,   ...
       'userdata','Trial and Error ...' , ...
       'callback','mirr_cb(''learn'',7,0,1,1,'''')' , ...
       'label','Learning by Doing !!!', ...
       'enable','off' );




% Store UIMenuHandles in  fig,'UserData'  *** !!! ***
set(MC(1,1),'userdata',m)

% Store Print and QuitHandle
eval( 'MC(6,4:5) = m(5:6);' , 'MC(6,4:5) = m(5:6)'';' )




MC(1,2) = axes( ...
'position' , [0 0 1 1] , ...
'color'    , [0 0 0] , ...
'xlim'     , xlim , ...
'ylim'     , ylim , ...
'xtick'    , [] , ...
'ytick'    , [] , ...
aspectprop1 , aspectval , ...
aspectprop2 , aspectval , ...
'drawmode' , 'fast', ...
'box'      , 'on'  , ...
'visible'  , 'off'   );   
 
hold on



mirr_draw('mirr');    % Draw Mirror

mirr_draw('magl');    % Draw MagLight


% Open MirrorControlWindow
mirr_cntr(xlim,ylim,MirrorXMax2)


figure(MC(1,1))

v = version;
if v(1) == '4'
 set(MC(1,1),'nextplot','replace')
else
 ii = 6; % Quit
   CB = [ 'mirr_cb(''' lower(label) ''',' int2str(ii) ','  ...
          int2str(childs(ii)) ',1,1,'''')' ];
 set(MC(1,1),'closerequestfcn',CB)
end

set(m,'enable','on')

set(MC(1,1),'windowbuttonupfcn','mirr_move(''up'','''')' , ...
            'windowbuttonmotionfcn','mirr_move('''','''')'      )

disp(' *** !!! ***   MIRROR: Use global Variables   *** !!! *** ')

end
% file_ok
