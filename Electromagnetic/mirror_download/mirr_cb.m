function mirr_cb(action,ii,jj,MCii,MCjj,kind)

% MIRR_CB    CallBacks for MirrorUIObjects 
%             (MirrorUIMenu and MirrorControlWindow)
%
%  requires MIRR_DRAW to apply ParameterChanges
%           MIRR_PRIN to Print Figure
%           MYZOOM    for Zoom
%
%  required by UIMenuCallbacks,    created in MIRROR    and
%              UIControlCallbacks, created in MIRR_CNTR
%



global MC  HMC0  HMC1 HHMC



if strcmp(lower(action),'quit')

  % Index for MC, contains Handles of Figures
  ii = [ 1 6 6 ] ;  % RowIndex
  jj = [ 1 1 3 ] ;  % ColumnIndex

  for kk = 1:length(ii)
   if any(get(0,'children')==MC(ii(kk),jj(kk)))
    delete(MC(ii(kk),jj(kk)))
   end
  end

  clear global MC

else

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%
% Mirror-UIMenu's


if strcmp(lower(action),'control')

  set(MC(6,1),'visible','on')
  set(0,'currentfigure',MC(6,1))


elseif strcmp(lower(action),'learn')

  m   = get(MC(1,1),'userdata');

  ud  = get(m(1,ii),'userdata');
  lab = get(m(1,ii),'label');
  
  set(m(ii),'label',ud,'userdata',lab)


elseif strcmp(lower(action),'refresh')
 
  refresh(MC(1,1));

elseif strcmp(lower(action),'print')
 
  mirr_prin(MC(1,1));  % Print of Figure( MC(1,1)) )


elseif strcmp(lower(action(1:4)),'zoom')
 
  m   = get(MC(1,1),'userdata');

  if strcmp(get(m(1,ii),'label'),'Zoom on')

   set(m(1,ii),'label','Zoom off', ...
               'userdata',get(MC(1,1),'windowbuttondownfcn') )

   mirr_zoom(MC(1,2),'zoom');

  else

   set(m(1,ii),'label','Zoom on'),

   mirr_zoom(MC(1,2),'off');

   set(MC(1,1),'windowbuttondownfcn',get(m(1,ii),'userdata') )
  end


%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%
% Mirror-UIControl's

elseif strcmp(lower(action),'push')
  % Hide

  set(MC(6,1),'visible','off')
  set(0,'currentfigure',MC(1,1))



elseif strcmp(lower(action),'edit')

 eval(['val=' get(HMC0(ii,jj),'string') ';' ] , ...
       'val=nan;'                                   )

 if get(HMC1(ii,jj),'max') >= val  &    ...
      val >= get(HMC1(ii,jj),'min')                      

   str = sprintf( get(HMC0(ii,jj),'userdata') , val);
   val = eval(str);

   set( HMC0(ii,jj) , 'string' , str )
   set( HMC1(ii,jj) , 'value'  , val )                 

   if strcmp(kind,'mirr') & jj==2
   % MirrorXMax new if Focus
      MC(5,2) = MC(5,2) * eval(str)/MC(2,3); 
   % the same for the other MirrorType
      ud = get(HMC0(ii,1),'userdata');
      set(HMC0(ii,1),'userdata',[ ud(1)*val/MC(2,3)  val ] );   
   end

   MC(MCii,MCjj) = val;

 else                                                      
 
   set( HMC0(ii,jj) , 'string' , ...
       sprintf( get(HMC0(ii,jj),'userdata') , MC(MCii,MCjj) )) 
 end



elseif strcmp(lower(action),'slider')

 val =  get(HMC1(ii,jj),'value');

 str =  sprintf( get(HMC0(ii,jj),'userdata') , val );                           

 MC(MCii,MCjj) = eval(str);

 set( HMC0(ii,jj) , 'string' , str );

 if strcmp(kind,'mirr') 

   if jj == 2
   % New MirrorSize (MirrorXMax) new if Focus
    
      % [ MirrorXmax2  MirrorSizeMax2 ]
      ud  = get(HMC0(ii,1),'userdata'); 

    % NewSize = OldSize * NewFocus/OldFocus
    % MC(5,2) = MC(5,2) * MC(MCii,MCjj)/ud(2); 

  
    % Weight by SizeMax !!!
      si_max = eval(eval(get(HHMC(5,2),'userdata')));

    % NewSize = OldSize * NewMax/OldMax 
      MC(5,2) = MC(5,2) * si_max(MC(2,4))/get(HHMC(5,2),'max');
      MC(5,2) = MC(5,2) + ( si_max(MC(2,4)) - MC(5,2) ) * ...
                          [ si_max(MC(2,4)) < MC(5,2) ];

    % the same for the other MirrorType
    %  ud(1) = ud(1)*MC(MCii,MCjj)/ud(2);

       ud(1) = ud(1) * si_max(3-MC(2,4))/ud(2);
       ud(1) = ud(1) + ( si_max(3-MC(2,4)) - ud(1) ) * ...
                       [ si_max(3-MC(2,4)) < ud(1) ];
      set(HMC0(ii,1),'userdata', [ ud(1) si_max(3-MC(2,4)) ] );
  

    % Set MirrorSizeControl
    % SizeMaxFormula in UserData

    set(HHMC(5,2),'value', MC(5,2) , ...
                   'max' , si_max(MC(2,4)) )
    eval( get(HHMC(5,2),'callback') )


   elseif jj == 3
   % Size
   
   end   


 end
 % mirr



elseif strcmp(lower(action),'popu')

 MirrTypeOld = MC(2,4);

 val = get(HMC0(ii,jj),'value');

 if xor([val==3],[MC(MCii,MCjj)==3])
  delete(MC(3,1));
  MC(3,1) = NaN;   % Clear old MagLight
  kind = 'magl';
 end
 
 MC(MCii,MCjj) = val;

 if strcmp(kind,'mirr')  &  MC(2,4) ~= MirrTypeOld
  % MirrorType-PopUpMenu
  % Get   MirrorXMax for new Mirror
  % Store MirrorXMax of old MirrorType in 'userdata'


    % [ MirrorXmax2  MirrorSizeMax2 ]    
    ud = get(HMC0(ii,jj),'userdata');

    % Weight by SizeMax !!!
      si_max = eval(eval(get(HHMC(5,2),'userdata')));
 
    set(HMC0(ii,jj),'userdata',[MC(5,2) si_max(3-MC(2,4)) ])

    MC(5,2) = ud(1);


    % Set MirrorSizeControl 
    % SizeMaxFormula in UserData

    set(HHMC(5,2),'value', MC(5,2) , ...
                   'max' , si_max(MC(2,4))   )
    eval( get(HHMC(5,2),'callback') )

    
  end

elseif strcmp(lower(action),'chec')
% Shadow

 sets = [ 'xor ' ; 'none' ];

 set(MC(MCii,1),'erasemode', ...
  deblank(sets(get(HMC0(ii,jj),'value')+1,:)))

 refresh(MC(1,1))

end



if strcmp(get(get(0,'callbackobject'),'type'),'uicontrol')
% Changes on ControlWindow
 mirr_draw(kind) 
end


if strcmp(kind,'mirr') & get(0,'currentfigure') == MC(6,1)
 
 % Changes on Mirror
 refresh(MC(1,1))

end

end
% Quit