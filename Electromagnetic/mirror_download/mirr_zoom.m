function hh=mirr_zoom(varargin);

% MYZOOM     My ZoomFunction
%
% H = MYZOOM  gives the Handles of the ZoomBox and RectBox.
% 
% MYZOOM(Axe , ... )  Initialized ZoomFunction 
%      for Axes Axe.
% 
% Set the MODE 
%  ... , 'zoom' , ...   Set Mode to Zoom (default)
%  ... , 'rect' , ...   Set Mode to Draw a Rectangle,
%                         doesn't Zoom !!!
%
% Set the Selection
%  ... , 'in', [xmin xmax ymin ymax] )
%                       Zoom's in  or   Draws a Rectangle 
%                        by given Coordinates 
%
%  ... , 'out',n )      Zoom's     or   Draws a Rectangle n-times out
%
% Control the Function
%  ... , 'off' )        Stop Zoom/RectFunction
%  ... , 'clear' )      Clears last ZoomInitialisation
%
%  ... , 'CB' , CallBackString , ...
%         Evaluate CallBackString after MouseButtonUpEvent
%
%   LeftMouseButton Zooms In
%  RightMouseButton Zooms Out
% 
%  2xLeftMouseButton  Zooms out to Original
%
%
% MYZOOM adds following 14-Element's-Row to the (Axe,'UserData'):
%
%   1         Axe            AxeHandle
%   2         is_Rect        0/1 
%   3         ZoomHandle     Handle for ZoomBox     (Line)
%   4         RectHandle     Handle for Rectangular (Line)
%   5 .. 6    Org.Size       Original Size of  get(Axe,'UserData')
%   7         is_Imag        found an IMAGE in    (Axe,'Children') 
%   8 .. 13   ImageSpacing   [xmin xmax xsteps  ymin ymax ysteps]  
%  14         Fig            FigureHandle
%

% Internal:
%
%  MYZOOM( Axe , 'down'   
%                'motion'           
%                'up'     , abs(old_motionCB) , abs(old_upCB) )
%


Nin = length(varargin);

VarArgIn = cell( 1 , Nin + (2-Nin)*[Nin < 2] + 1 );

VarArgIn(1: 2 ) = { gca  0 };
VarArgIn(1:Nin) =  varargin ;

if Nin == 0
 VarArgIn = { gca 'zoom' };
end

NVin = length(VarArgIn) - 1;

 
if isstr(VarArgIn{1});
 VarArgIn(1:NVin+1) = { gca  VarArgIn{[1:NVin]} };
 Nin = Nin + 1;
end

if length(VarArgIn) < 2
 VarArgIn(2) = { 'zoom' };
end

hh = []; % OutPutArgument



% search for axe
ok = 1;  
eval('ok = get(VarArgIn{1}(1),''type'');','ok=0;')
if ~ok
 error('AxeHandle is not an valid GraphicObject.')
elseif ~strcmp(lower(ok),'axes')
 error('AxeHandle is not an valid AxesObject.')
end

ZoomAxe = VarArgIn{1}(1);
ZoomFig = get(ZoomAxe,'parent');


% StringFormat for Handle
clear eps
form = sprintf('%%.%.0ff',floor(abs(log(eps)/log(10))) );
AxeString = sprintf(form,ZoomAxe);
% we need this string for WindowButtonMotion/UpFcn  



strings = [ 'zoom ' ; ...
            'rect ' ; ...
            'off  ' ; ...
            'clear' ; ...
            'cb   ' ; ...
            'in   ' ; ...
            'out  '        ];


is_str = zeros(size(strings,1),1);  % <1> if String is selected

CB = '';

for ii = 1:Nin
 val = VarArgIn{ii};
 for jj = 1:size(strings,1)
  if strcmp(deblank(strings(jj,:)),lower(val))
   if any(jj==[5 6 7])
   % cb , in, out
    if nargin >= ii+1
     val = VarArgIn{ii+1};
     if ~isstr(val) & any(jj==[6 7])
      is_str(jj) = ii+1;
     elseif isstr(val) & jj==5
      is_str(jj) = 1;
      CB = VarArgIn{ii+1};
     end
    end
   else
    is_str(jj) = 1;
   end
  end
 end
end


% better for later
is_zoom = is_str(1);
is_rect = is_str(2);


NewBox = [];
if is_str(6)  % 'in'
 NewBox = VarArgIn{is_str(6)};
end


Nout = 0;
if is_str(7)  % 'out'
 Nout = VarArgIn{is_str(7)};
end



%******************************************
% CLEAR ZOOM
%------------------------------------------

if is_str(4)   % 'clear'

   not_found = 1;

 ZoomUU = get(ZoomAxe,'userdata');
 Zoomll = size(ZoomUU,1)+1;

 if size(ZoomUU,2) >= 14
  while not_found  &   Zoomll > 1 
   Zoomll = Zoomll - 1;
   if sum( size(ZoomUU) >= ZoomUU(Zoomll,5:6) ) & ...
         ( ZoomUU(Zoomll, 1) == ZoomAxe )       & ...
         ( ZoomUU(Zoomll,14) == ZoomFig )
    if sum( ZoomUU(Zoomll,3) == get(ZoomAxe,'children') ) | ... 
       sum( ZoomUU(Zoomll,4) == get(ZoomAxe,'children') )
       not_found = 0;
       eval('delete(ZoomUU(Zoomll,3))','ok=0;')
       eval('delete(ZoomUU(Zoomll,4))','ok=0;')
       ZoomUU = ZoomUU(1:ZoomUU(Zoomll,5),1:ZoomUU(Zoomll,6));
       set(ZoomAxe,'userdata',ZoomUU)
       set(ZoomFig,'windowbuttondownfcn','')
    end
   end
  end
  % while
 end




%******************************************
% ZOOM OFF
%------------------------------------------

elseif is_str(3)  % 'off'

 
 set(ZoomFig,'windowbuttondownfcn'  ,'')




 
%*********************************
% Mouse DOWN
%---------------------------------

elseif  strcmp(VarArgIn{2},'down') 


 more off, 


  ZoomUU     = get(ZoomAxe,'userdata');
  Zoomll     = size(ZoomUU,1); 
  ZoomImag   = ZoomUU(Zoomll,7:13);  
  ZoomRect   = ZoomUU(Zoomll,2);  
  ZoomHandle = ZoomUU(Zoomll,3+ZoomRect); 
  Zoomuu     = get(ZoomHandle,'userdata'); 


  % Store old WindowButtonMotion/UpFcn
  %  as  String for a Vector of AsciiCodes

  mot_fcn = get(ZoomFig,'windowbuttonmotionfcn');
   up_fcn = get(ZoomFig,'windowbuttonupfcn'    );

  mot_fcn = [ '['  sprintf('%4.0f',abs(mot_fcn)) ']' ];
   up_fcn = [ '['  sprintf('%4.0f',abs( up_fcn)) ']' ];

  set(ZoomFig,'windowbuttonupfcn', [ ...
            'mirr_zoom(' AxeString ',''up'',' ...
                    mot_fcn ',' up_fcn ');' ])


  if ~isempty(Zoomuu)
    set(ZoomHandle , ...
    'xdata',nan*ones(5,1) , ...
    'ydata',nan*ones(5,1) , ...
    'visible','off' )
  end


 if strcmp(get(ZoomFig,'selectiontype'),'normal')
 % ----------------------------------------------
 % LeftButton Zoom in
 % ..............................................

  Zoomcc = get(ZoomAxe,'currentpoint');
  set(ZoomHandle , ...
    'xdata',Zoomcc(1,[1 1 1 1 1]) , ...
    'ydata',Zoomcc(1,[2 2 2 2 2]) , ...
    'visible','on' , ...
    'userdata',[Zoomuu;[Zoomcc(1,[1 1]),Zoomcc(1,[2 2])]]  )

  set(ZoomFig,'windowbuttonmotionfcn', [ ...
  'mirr_zoom('  AxeString  ',''motion'');' ])


 elseif strcmp(get(ZoomFig,'selectiontype'),'open') 
 % ------------------------------------------------
 % 2xLeftButton Zoom to first set
 % ................................................

  set(ZoomHandle,'userdata',Zoomuu(1,:),'visible','on')

 elseif strcmp(get(ZoomFig,'selectiontype'),'alt')
 % -------------------------------------------------
 % RightButton Zoom out 1 time
 % .................................................

  if length(Zoomuu(:,1)) > 1 
   set(ZoomHandle,'userdata',Zoomuu(1:size(Zoomuu,1)-1,:), ...
                  'visible' ,'on')
   if ZoomRect
    set(ZoomHandle,'xdata',Zoomuu(size(Zoomuu,1)-1,[1 2 2 1 1]), ...
                   'ydata',Zoomuu(size(Zoomuu,1)-1,[3 3 4 4 3])      );
   end  
  end


 end


%*****************************************************
% Mouse MOTION
%-----------------------------------------------------

elseif  strcmp(VarArgIn{2},'motion')


  ZoomUU     = get(ZoomAxe,'userdata');
  Zoomll     = size(ZoomUU,1); 
  ZoomImag   = ZoomUU(Zoomll,7:13);  
  ZoomRect   = ZoomUU(Zoomll,2);  
  ZoomHandle = ZoomUU(Zoomll,3+ZoomRect); 
  Zoomuu     = get(ZoomHandle,'userdata');

 Zoomxx = get(ZoomHandle,'xdata'); 
 Zoomyy = get(ZoomHandle,'ydata');
 Zoomcc = get(ZoomAxe,'currentpoint');

 Zoomuu(size(Zoomuu,1),:) = [Zoomxx(1) Zoomcc(1,1) Zoomyy(1) Zoomcc(1,2)];

 set(ZoomHandle,'xdata',[Zoomxx([1 2]) Zoomcc(1,[1 1]) Zoomxx(5)] ,  ...
                'ydata',[Zoomyy(1) Zoomcc(1,[2 2]) Zoomyy([4 5])] ,  ... 
                'userdata',Zoomuu                                         ) 



%***************************************************************
% Mouse UP
%---------------------------------------------------------------

elseif strcmp(VarArgIn{2},'up')


 if any( ZoomFig == get(0,'children') ) 

  ZoomUU     = get(ZoomAxe,'userdata');
  Zoomll     = size(ZoomUU,1); 
  ZoomImag   = ZoomUU(Zoomll,7:13);  
  ZoomRect   = ZoomUU(Zoomll,2);  
  ZoomHandle = ZoomUU(Zoomll,3+ZoomRect); 

  more off,  

   % Set old WindowButtonMotion/UpFcn back

   set(ZoomFig,'windowbuttonmotionfcn' , char(VarArgIn{3}) ),  
   set(ZoomFig,'windowbuttonupfcn'     , char(VarArgIn{4}) ),
  

   Zoomuu  = get(ZoomHandle,'userdata' );   
   Zoomuu0 = Zoomuu(1:size(Zoomuu,1)-1,:);  
   Zoomuu  = Zoomuu(size(Zoomuu,1),:);  

   if ~diff(Zoomuu(1:2)) & ~diff(Zoomuu(3:4))
    Zoomuu = [];
   end

  if ~ZoomRect & ~isempty(Zoomuu)  

   if ZoomImag(1)
    xline = linspace(ZoomImag(2),ZoomImag(3),ZoomImag(4));  
    yline = linspace(ZoomImag(5),ZoomImag(6),ZoomImag(7));  
    [hilf,xii] = min(abs(xline-Zoomuu(1)));  
    [hilf,yii] = min(abs(yline-Zoomuu(3)));  
    Zoomuu(1) = xline(xii);   
    Zoomuu(3) = yline(yii);   
    [hilf,xii] = min(abs(xline-Zoomuu(2)));  
    [hilf,yii] = min(abs(yline-Zoomuu(4)));  
    Zoomuu(2) = xline(xii);   
    Zoomuu(4) = yline(yii);   
   end

   if diff(Zoomuu(1:2)) & diff(Zoomuu(3:4))
     set(ZoomAxe,'xlim' ,sort(Zoomuu(1:2)),  ...
                 'ylim' ,sort(Zoomuu(3:4)) )
     refresh(ZoomFig)
   else
     Zoomuu = [];
   end

  end

   sets = {'off' ; 'on' };

   set(ZoomHandle,'userdata' , [Zoomuu0 ; Zoomuu] , ...
                  'visible'  , sets{ZoomRect+1}         )   
 
  eval( get(ZoomHandle,'tag') , ... 
       [' disp(''    Error in UserCallBackString.' ...
               '  Type >> lasterr  to get detailed informations.'')']  )
 

  more on  

 end


 

%***********************************************************
% new zoom
%----------------------------------------------------------

else


   hold_state = get(ZoomAxe,'nextplot');



   % Search, if Zoom was on

   hh = [ 0  0 ];  %  [ ZoomHandle  RectHandle ]
   old_rect = 0;

    ZoomUU = get(ZoomAxe,'userdata');
    Zoomll = size(ZoomUU,1) + 1;

    if size(ZoomUU,2) >=14 
     while ~all(hh)   &   Zoomll > 1 
      Zoomll = Zoomll - 1;
      if sum( size(ZoomUU) >= ZoomUU(Zoomll,5:6) ) & ...
            ( ZoomUU(Zoomll, 1) == ZoomAxe )       & ...
            ( ZoomUU(Zoomll,14) == ZoomFig )
        
        % Search for RectHandles
        hh = ZoomUU(Zoomll,3:4) * ...
             [any( ZoomUU(Zoomll,3) == get(ZoomAxe,'children') ) & ...
              any( ZoomUU(Zoomll,4) == get(ZoomAxe,'children') )  ];  

        if hh(1) 
        % Found Zoom ON

          % Store ImageInformations
            is_imag  = ZoomUU(Zoomll,7);
          imag_space = ZoomUU(Zoomll,8:13);
        
          % Store RectInformations
            old_rect = ZoomUU(Zoomll,2);

          % Delete old ZoomUU-Vector in ZoomAxe,'userdata';
          %  we set them later new
          ZoomUU = ZoomUU(1:ZoomUU(Zoomll,5),1:ZoomUU(Zoomll,6));

          set(ZoomAxe,'userdata',ZoomUU)

        end
      end
     end
     % while
    end


    if ~hh(1)
    % Didn't found Zoom

     % search for image
        is_imag = 0;  
     imag_space = [0 0 0 0 0 0];

     for child = get(ZoomAxe,'children')'
      is_imag=strcmp(lower(get(child,'type')),'image');
      if is_imag
       imag_si = size(get(child,'Cdata'));
       xlim = get(ZoomAxe,'xlim');
       ylim = get(ZoomAxe,'ylim');
       imag_space = [xlim imag_si(2)+1 ylim imag_si(1)+1];
       break 
      end
     end
    end
    % ~hh(1)


   new_rect = ( old_rect*[~is_rect] + is_rect ) * [~is_zoom];



   ZoomXlim = get(ZoomAxe,'xlim');
   ZoomYlim = get(ZoomAxe,'ylim');

   set(ZoomAxe,'xlim'     , ZoomXlim , ...
               'ylim'     , ZoomYlim , ...
               'nextplot' , 'add'         )



   % Create 2 RectHandles for Zoom and Rect

   lwidth = [ 1      1.5 ];
   lstyle = { '--' ; '-' };

   for ii = 1:2
     if ~hh(ii)
         hh(ii) = plot(nan*ones(1,5), ...
                       nan*ones(1,5), ...
               'linewidth', lwidth(ii), ...
               'linestyle', lstyle{ii}, ...
               'color'    , [1 0 0 ], ...
               'erasemode', 'xor', ...
               'clipping' , 'off' , ...
               'parent'   , ZoomAxe , ...
               'userdata' , [ ZoomXlim  ZoomYlim ] , ...
               'visible'  , 'off'        ); 
     end
   end

   sets = { 'off' ; 'on' };
   set(hh(2),'visible',sets{new_rect+1} )


   Zoomuu = [ get(hh(new_rect+1),'userdata') ; zeros(1,4) ];
   Zoomll = size(Zoomuu,1) - 1 + [size(Zoomuu,1)==1];
 
   if ~Nout & ~new_rect & ...
      ~all( [ [ sort(Zoomuu(Zoomll,1:2))==ZoomXlim ] ...
              [ sort(Zoomuu(Zoomll,3:4))==ZoomYlim ] ] )
    Zoomuu0 = [ ZoomXlim ZoomYlim ; NewBox ];
   else
    Zoomuu0 = NewBox;
   end


    Zoomuu = [ Zoomuu(1:Zoomll-all(~Zoomuu(Zoomll,:)),:) ; ...
               Zoomuu0     ];

   Zoomll = size(Zoomuu,1);
     Nout = Nout + (Zoomll-1 - Nout) * [ Nout > Zoomll-1 ] + ~Zoomll;
   Zoomuu =  Zoomuu( 1 : Zoomll-Nout , : ) ;

   set(hh(new_rect+1),'userdata',Zoomuu)

   if ~isempty(Zoomuu)
    LastBox = Zoomuu(size(Zoomuu,1),:);
   end

   if is_str(5)        % UserCallBack
    set(hh(new_rect+1),'tag',CB)
   end         
          

   set(ZoomAxe,'nextplot',hold_state)



   ZoomUU = get(ZoomAxe,'userdata');   
   Zoomll = size(ZoomUU);

   ZoomUU(Zoomll(1)+1,1:14) = ...
     [ZoomAxe new_rect  hh   Zoomll is_imag imag_space ZoomFig];

   set(ZoomAxe,'userdata',ZoomUU)



  if ~[ is_str(6) | is_str(7)]   % ~[ 'in' or 'out' ]

    set(ZoomFig,'windowbuttondownfcn', ...
          ['mirr_zoom('  AxeString ',''down'');'])

  else

   if new_rect
    set(hh(2),'xdata',LastBox([1 1 2 2 1]) , ...
              'ydata',LastBox([3 4 4 3 3]) , ...
              'visible','on')
   end
   mirr_zoom(ZoomAxe,'up',abs(get(ZoomFig,'windowbuttonmotionfcn')), ...
                       abs(get(ZoomFig,'windowbuttonupfcn'    ))      );

  end  
 

   if nargout == 0
    hh = [];
   end


end
