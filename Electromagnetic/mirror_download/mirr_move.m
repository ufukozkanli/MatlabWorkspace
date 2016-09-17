function  mirr_move(action,kind)

% MIRR_MOVE  Control of MouseEvents on Figure
%
% requires MIRR_DRAW
%
% LEFTMouseButton pressed and hold on MagLight MOVE's it,
% RIGHT ...         ...       ...      ...     ROTATE it,
%
% LEFT  ...         ...       ...     FocusPoint MOVE's it,
% LEFT  ...         ...       ... InnerMirrorEnd MOVE's it,
% LEFT  ...         ...   ... OutherMirrorBase changes the Width.
%    
%


global MC HMC0 HHMC


   cp = get(MC(1,2),'currentpoint');  

 selection = get(MC(1,1),'selectiontype');


if strcmp(action,'down')

  move_act = '';

  if strcmp(selection,'normal')
 
    move_act = 'move';

  elseif strcmp(selection,'alt')  &  strcmp(kind,'magl')

    move_act = 'rot';

  end

  up_act = 'up';
  up_ext = 'refresh';
  if strcmp(kind,'magl')
   up_ext = '';
  end
       

  set( MC(1,1)                                   , ...
'windowbuttonmotionfcn'                          , ...
   ['mirr_move(''' move_act ''',''' kind ''')' ] , ...
'windowbuttonupfcn'                              , ...
   ['mirr_move('''   up_act ''',''' kind '''),' up_ext  ])


  % Store ButtonDownPosition

  MC(1:2,5) = cp(1,1:2)';



elseif strcmp(action,'move') &  strcmp(kind,'magl')

  lims = [ get(HHMC(3,2),'min')  get(HHMC(3,3),'min') ; ...
           get(HHMC(3,2),'max')  get(HHMC(3,3),'max')       ];

  MCneu = MC(3,2:3) + ( cp(1,1:2) - MC(1,3:4) );

  ok = [ sign( lims - ones(2,1)*MCneu ) == [-1 -1 ; 1 1 ] ];         
  
  
  MC(3,2:3) = MC(3,2:3) + ( MCneu - MC(3,2:3) ) * all(all(ok)) ;


  set(HHMC(3,2),'value',MC(3,2))
  eval( get(HHMC(3,2),'callback') )

  set(HHMC(3,3),'value',MC(3,3))
  eval( get(HHMC(3,3),'callback') )

  mirr_draw('magl');
 


elseif strcmp(action,'move') &  strcmp(kind,'focus')

  lims = [  get(HHMC(2,3),'min')   get(HHMC(2,3),'max') ];

  MCneu = MC(2,3) + ( cp(1,1) - MC(1,3) );

  ok = [ sign( lims - MCneu ) == [-1 1] ];

  MC(2,3) = MC(2,3) + ( MCneu - MC(2,3) ) * all(ok);

  % MirrorXMax new (in mirr_cb)

  set(HHMC(2,3),'value',MC(2,3))
  eval( get(HHMC(2,3),'callback') )

  mirr_draw('mirr');


elseif strcmp(action,'move') &  strcmp(kind,'edge')
% Size

  lims = [  get(HHMC(5,2),'min')   get(HHMC(5,2),'max') ];

  MCneu = MC(5,2) + ( cp(1,1) - MC(1,3) );

  ok = [ sign( lims - MCneu ) == [-1 1] ];

  MC(5,2) = MC(5,2) + ( MCneu - MC(5,2) ) * all(ok);


  set(HHMC(5,2),'value',MC(5,2))
  eval( get(HHMC(5,2),'callback') )

  mirr_draw('mirr');


elseif strcmp(action,'move') &  strcmp(kind,'base')
% Width

  lims = [  get(HHMC(5,1),'min')   get(HHMC(5,1),'max') ];

  MCneu = MC(5,1) - ( cp(1,1) - MC(1,3) ); % !!! "-" !!!

  ok = [ sign( lims - MCneu ) == [-1 1] ];

  MC(5,1) = MC(5,1) + ( MCneu - MC(5,1) ) * all(ok);

  set(HHMC(5,1),'value',MC(5,1))
  eval( get(HHMC(5,1),'callback') )

  mirr_draw('mirr');


elseif strcmp(action,'rot')

  MC(3,4) = MC(3,4) + 180/pi * ( ...
            atan2(cp(1,2)-MC(3,3),-(cp(1,1)-MC(3,2))) - ...
            atan2(MC(1,4)-MC(3,3),-(MC(1,3)-MC(3,2)))       );

  MC(3,4) = MC(3,4)-360*floor(MC(3,4)/360);
  MC(3,4) = MC(3,4)-360*[MC(3,4)>180];

  set(HHMC(3,4),'value',MC(3,4))
  eval( get(HHMC(3,4),'callback') )

  mirr_draw('magl')
 

elseif strcmp(action,'up')

  set(MC(1,1),'windowbuttonmotionfcn','mirr_move('''','''')')
  set(MC(1,1),'windowbuttonupfcn','mirr_move(''up'','''')')

end


  % Store PointerPosition
  MC(1,3:4) = cp(1,1:2);

 
set(HMC0(1,1),'string' , ... 
              sprintf(get(HMC0(1,1),'userdata'),cp(1,1)))
 
set(HMC0(1,2),'string' , ...
              sprintf(get(HMC0(1,1),'userdata'),cp(1,2)))
