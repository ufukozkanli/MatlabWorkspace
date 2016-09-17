function mirr_prcb(fig,action,filename)

% MIRR_PRCB  CallBacks for UIObjects of MIRR_PRIN 
%
%   MIRR_PRCB( Fig , ACTION , FileName )
%
%
% ACTION = ... 'back'
%              'print'
%              'device'
%              'onlyf'
%              'tofiles'
%              'setfile'
%



global MC Hpr0 Hpr3



%***************************************************
% CALLBACKS
%---------------------------------------------------

if strcmp(lower(action),'back')

 close(MC(6,3))

       MC(6,3) = NaN;          % PrintFigure

   set(MC(6,4),'enable','on')  % PrintUIMenu

 set(0,'currentfigure',MC(1,1))

 clear global Hpr0 Hpr3

 

elseif strcmp(lower(action),'print')

 figs = get(fig,'userdata');      
 Parent = figs(1);                
 device = ' '; option=' '; printer=' '; 
 stringD = get(Hpr0(Parent,1),'string'); 
 device = [' -d' deblank(stringD(get(Hpr0(Parent,1),'value'),1:8)) ' ']; 
 if stringD(get(Hpr0(Parent,1),'value'),size(stringD,2)-1)=='1' 
  stringO = get(Hpr0(Parent,6),'string'); 
  if get(Hpr0(Parent,6),'value') > 1, 
   option = [' -' deblank(stringO(get(Hpr0(Parent,6),'value'),1:8)) ' ' ]; 
  end, 
 end,  
 kenn = stringD(get(Hpr0(Parent,1),'value'),size(stringD,2));  
 if kenn-48 & get(Hpr0(Parent,4),'value'), 
  printer = [' ' fliplr(deblank(fliplr(get(Hpr0(Parent,3),'string'))))]; 
 elseif kenn-48==1 & ~get(Hpr0(Parent,4),'value'), 
  printer = [' -P' fliplr(deblank(fliplr(get(Hpr0(Parent,2),'string'))))]; 
 end,    
 clear stringD,
   mirr_msg(                           ... 
     'position'        , [100 200 450 120], ... 
     'style'           , 'Warning'      , ...
     'Name'            , 'Print Figure' , ...
     'BackgroundColor' , [1 1 1]          , ...
     'ButtonStrings'   , 'Ok'           , ...
     'ButtonCalls'     , 'delete(gcf)'  , ...
     'ForegroundColor' , [0 0 0]          , ...
     'Replace'         , 'on'           , ...
     'TextString'      , [ setstr(13) setstr(10) ... 
                  '   Evaluate Printer Command'  ...
      setstr(13) setstr(10)  setstr(13) setstr(10) ...
       ['    ' setstr(187) ' print -f'         ...
 int2str(Parent) option device printer ] ] );
   fid_test  = fopen('mirr_prin.txt','r'); 
 if fid_test ~= -1,    
  delete mirr_prin.txt, 
  fclose(fid_test);    
 end, 
 diary mirr_prin.txt, 
 ok1 = 1; 
  eval([' print -f' int2str(Parent) ... 
        option device printer],'ok1=0;'), 
 pause(0.1), 
 diary,  
 diary,  
 message = '   '; ok2 = 1; 
 fidin = fopen('mirr_prin.txt','r'); 
 while 1, 
  bb = fgetl(fidin); 
  if bb ~= -1,       
   message = str2mat(message,bb); 
  else,   
   break, 
  end,    
 end,     
 fclose(fidin); 
  delete  mirr_prin.txt
 if message == 32, 
  ok2 = 1; 
 else, 
  ok2 = 0; 
 end, 
if ~ok1 | ~ok2,    
 if ~ok1, 
  diag_txt = [ setstr(13) setstr(10) lasterr]; 
 else, 
  message(1,:) = []; 
  diag_txt = setstr([meshgrid([13 10],message(:,1)) ... 
                message]); 
 end, 
   mirr_msg(                           ... 
     'position'        , [100 200 350 150], ... 
     'style'           , 'error'      , ...
     'Name'            , 'Error in Evaluating Printer Command' , ...
     'BackgroundColor' , [1 1 1]          , ...
     'ButtonStrings'   , 'Ok'           , ...
     'ButtonCalls'     , 'delete(gcf)'  , ...
     'ForegroundColor' , [0 0 0]          , ...
     'Replace'         , 'on'           , ...
     'TextString'      , diag_txt )  
 end,  

 refresh(Parent)

elseif strcmp(lower(action),'device')

 figs = get(fig,'userdata');      
 Parent = figs(1);                
 string = get(Hpr0(Parent,1),'string'); 
 if string(get(Hpr0(Parent,1),'value'),size(string,2)-1)~='1', 
  set(Hpr0(Parent,6),'enable','off'), 
 else, 
  set(Hpr0(Parent,6),'enable','on'), 
 end, 
 kenn = string(get(Hpr0(Parent,1),'value'),size(string,2));  
 clear string , 
 if kenn=='3', 
  set(Hpr0(Parent,4),'value',1), 
  eval(get(Hpr0(Parent,4),'callback')), 
 elseif kenn=='0', 
  set(Hpr0(Parent,2),'enable','off'), 
  set(Hpr0(Parent,3),'enable','off'), 
  set(Hpr0(Parent,4),'enable','off'), 
  set(Hpr0(Parent,5),'enable','off'), 
 else, 
  set(Hpr0(Parent,4),'enable','on'), 
  eval(get(Hpr0(Parent,4),'callback')), 
 end,  


elseif strcmp(lower(action),'onlyf')

 figs = get(fig,'userdata');      
 Parent = figs(1);                
 string = get(Hpr0(Parent,1),'string'); 
 kenn = string(get(Hpr0(Parent,1),'value'),size(string,2));  
 clear string, 
 if kenn=='3', 
  set(Hpr0(Parent,4),'value',1), 
 end, 
val = get(Hpr0(Parent,4),'value'); 
if val == 1; 
  set(Hpr0(Parent,2),'enable','off'), 
  set(Hpr0(Parent,3),'enable','on'), 
  set(Hpr0(Parent,5),'enable','on'), 
else, 
  set(Hpr0(Parent,2),'enable','on'), 
  set(Hpr0(Parent,3),'enable','off'), 
  set(Hpr0(Parent,5),'enable','off'), 
end,  


elseif strcmp(lower(action),'tofiles')

 clear Parent
 global Parent
 figs = get(fig,'userdata');      
 Parent = figs(1);                
[filename,pathname] = uiputfile('*.*', ... 
                  [ 'Select File to print']); 
 if isempty(filename), filename = 0; end, 
if filename ~= 0, 
 fidtest = fopen([pathname,filename],'r');  
  if fidtest == -1,                                        
    set(Hpr0(Parent,3),'string',[pathname,filename]), 
  else, 

    fclose(fidtest);                                   
     diag_txt = [ '  Selected File '   , ... 
               [pathname,filename]  , ... 
 ' exist.'  setstr(13) setstr(10)  setstr(13) setstr(10) ,  ...
 '  Press <Ok> to accept  or  <Cancel> ' ];  
     ButtonStrings = 'Ok|Cancel';                   
     ButtonCalls = [ ...  
 'delete(gcf), global Parent, ' , ...
 'mirr_prcb(Parent,''setfile'',''' [pathname,filename] ''') ' ...
 ', clear global Parent | delete(gcf), clear global Parent'  ]; 
    mirr_msg(                    ...
     'position'        , [100 200 450 150]  , ...
     'style'           , 'warning'        , ...
     'Name'            , 'Warning'        , ...
     'BackgroundColor' , [1 1 1]            ,  ...
     'ButtonStrings'   , ButtonStrings      ,  ...
     'ButtonCalls'     , ButtonCalls        ,  ...
     'ForegroundColor' , [0 0 0]            ,  ...
     'Replace'         , 'on'             , ... 
     'TextString'      , [                    ...
      setstr(13) setstr(10)  diag_txt ] );      
   end, 
end,                


elseif strcmp(lower(action),'setfile')

  set(Hpr0(fig,3),'string',filename)

end
 
