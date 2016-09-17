function fig = mirr_msg(p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7,p8,v8,p9,v9)
% MIRR_MSG      Displays a Dialog Box.
%       FIG =  MIRR_MSG(P1,V1,...) displays a dialog box.
%       Valid Param/Value pairs include
%       Style              error  | warning  | help  |  question
%       Name               string
%       Replace            on | off
%       Resize             on | off
%       BackgroundColor    ColorSpec
%       ButtonStrings      'Button1String | Button2String | ... ' 
%       ButtonCalls        'Button1Callback | Button2Callback | ... '
%       ForegroundColor    ColorSpec
%       Position           [x y width height]
%                          [x y] - centers around screen point
%       TextString         string
%       Units              pixels | normal | cent | inches | points
%       UserData           matrix
%
%       Note: Until dialog becomes built-in, set and get
%             are not valid for dialog objects.
%
%             At most three buttons are allowed.
%
%             The callbacks are ignored for "question" dialogs.
%   
%             If ButtonStrings / CuttonCalls are unspecified then it
%             defaults to a single "OK" button which removes the figure.
%
%             There's still problems with making the question
%             dialog modal.
%
%             The entire Parameter name must be passed in.
%             (i.e. no automatic completion).
%
%             Nothing beeps yet. 
%
%       See also ERRORDLG, HELPDLG, WARNDLG, QUESTDLG

%       DefaultButton  1  | ... |  Buttons

%	Author(s): A. Potvin, 5-1-93, 2-4-94
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.15 $  $Date: 1994/08/01 18:17:24 $

% Error checks
nargs = nargin;
if rem(nargs,2),
   error('Param value pairs expected')
end

% Default values
Style = 'help';
TextString = 'Default help string.';
TextSize = size(TextString);
numButtonstrings = 1;
numButtoncalls = 1;
Button1String = 'OK';
Button1Call = 'delete(gcf)';
Button2Call = '';
Button3Call = '';
DlgName = 'Help Dialog';
Position = [];
Resize = 'on';
Scroll = 'Off';
Replace = 'on';
Units = 'pixels';
UserData = [];
DefaultButton = 1;
ForegroundColor = get(0,'DefaultUIControlForegroundColor');
BackgroundColor = get(0,'DefaultUIControlBackgroundColor');


% Recover Param/Value pairs from argument list
for i=1:2:nargs,
   Param = eval(['p' int2str((i-1)/2 +1)]);
   Value = eval(['v' int2str((i-1)/2 +1)]);
   if ~isstr(Param),
      error('Parameter must be a string')
   elseif size(Param,1)~=1,
      error('Parameter must be a non-empty single row string.')
   end
   Param = lower(Param);
   if strcmp(Param,'style'),
      Style = lower(Value);
      if ~isstr(Style),
         error('Style must be a string.')
      elseif ~(strcmp(Style,'help') | strcmp(Style,'warning') | ...
               strcmp(Style,'error') | strcmp(Style,'question')),
         error('Style must be error | help | warning | question')
      end
   elseif strcmp(Param,'name'),
      DlgName = Value;
      if ~isstr(DlgName),
         error('Name must be a string.')
      end
   elseif strcmp(Param,'textstring'),
      TextString = Value;
      if ~isstr(TextString),
         error('TextString must be a string.')
      end
      TextSize = size(TextString);
      if (TextSize(1)==1) & isempty(find(TextString==' ')),
         % Candidate file
         fid = fopen(TextString);
         if fid~=-1,
            % File opened successfully
            TextString = setstr((fread(fid))');
            fclose(fid);
         end
      end
      comp = computer;
      if strcmp(comp(1:2),'MA'),
         % Replace only tabs with spaces since character 13 is a newline
         ind = find(TextString==9);
      else
         % Replace all tabs and character 13's with spaces
         ind = find((TextString==9) | (TextString==13));
      end
      if ~isempty(ind),
         Space = setstr(32);
         TextString(ind) = Space(ones(size(ind)));
      end
      temp = find((TextString==10) | (TextString==13));
      if ~isempty(temp),
         TextSize = [length(temp) max(diff(temp))];
      end
   elseif strcmp(Param,'backgroundcolor'),
      BackgroundColor = Value;
   elseif strcmp(Param,'buttonstrings'),
      Button1String = Value;
      if ~isstr(Button1String),
         error('ButtonStrings must be a string.')
      else
         DivLines = find(Button1String=='|');
         l = length(Button1String);
         numButtonstrings = length(DivLines)+1;
         if numButtonstrings>3,
            error('Too many buttons.')
         elseif numButtonstrings==2,
            Button2String = Button1String(DivLines+1:l);
            Button1String(DivLines:l) = [];
         elseif numButtonstrings==3,
            Button2String = Button1String(DivLines(2)+1:l);
            Button3String = Button1String(DivLines(1)+1:DivLines(2)-1);
            Button1String(DivLines(1):l) = [];
         end
      end
   elseif strcmp(Param,'buttoncalls'),
      Button1Call = Value;
      if ~isstr(Button1Call),
         error('ButtonCalls must be a string.')
      else
         DivLines = find(Button1Call=='|');
         l = length(Button1Call);
         numButtoncalls = length(DivLines)+1;
         if numButtoncalls>3,
            error('Too many buttons.')
         elseif numButtoncalls==2,
            Button2Call = Button1Call(DivLines+1:l);
            Button1Call(DivLines:l) = [];
         elseif numButtoncalls==3,
            Button2Call = Button1Call(DivLines(2)+1:l);
            Button3Call = Button1Call(DivLines(1)+1:DivLines(2)-1);
            Button1Call(DivLines(1):l) = [];
         end
      end
   elseif strcmp(Param,'foregroundcolor'),
      ForegroundColor = Value;
   elseif strcmp(Param,'defaultbutton'),
      DefaultButton = Value;
   elseif strcmp(Param,'position');
      Position = Value;
   elseif strcmp(Param,'replace');
      Replace = Value;
   elseif strcmp(Param,'resize'),
      Resize = Value;
   elseif strcmp(Param,'scroll'),
      Scroll = Value;
   elseif strcmp(Param,'units');
      Units = Value;
   elseif strcmp(Param,'userdata'),
      UserData = Value;
   else
      error(['Unknown parameter: ' Param])
   end
end

% Few more error checks before creating dialog
if numButtonstrings~=numButtoncalls & ~strcmp(Style,'question')
   error('Number of defined buttons does not equal number of defined calls.')
else
   Buttons=numButtonstrings;
end
if (Buttons==1) & strcmp(Style,'question'),
   error('Question dialog expects more than one button.')
end


% Check if figure is already on screen and Replace is on
if strcmp(Replace,'on'),
   [flag,fig] = figflag(DlgName);
   if  flag,
      % No need to create new dialog
      return
   end
end

% Get layout parameters
layout
StdButtonSize = [mOKButtonWidth mOKButtonHeight];
[PosR,PosL] = size(Position);
if PosL<4,
   % Define default position
   ScreenUnits = get(0,'Units');
   set(0,'Unit','pixels');
   ScreenPos = get(0,'ScreenSize');
   set(0,'Unit',ScreenUnits);
   mCharacterWidth = 7;
   FigWH = fliplr(TextSize).*[mCharacterWidth mLineHeight] ...
           +[2*(mEdgeToFrame+mFrameToText) 3*mLineHeight+mOKButtonHeight];
   MinFigW = Buttons*(StdButtonSize(1)+mFrameToText) + ...
             2*(mEdgeToFrame+mFrameToText);
   FigWH(1) = max([FigWH(1) MinFigW]);
   FigWH = min(FigWH,ScreenPos(3:4)-50);
   if PosL==0,
      Position = [(ScreenPos(3:4)-FigWH)/2 FigWH];
   elseif PosL==2,
      Position = [(Position-FigWH)/2 FigWH];
   else
      error('Position value must be 1x2 or 1x4 vector.');
   end
   Position(1:2) = max(Position(1:2),[0 0]);
elseif (PosL==4) & (PosR==1),
   FigWH = Position(3:4);
else
   error('Position value must be 1x2 or 1x4 vector.');
end
if any(Position<0),
   error('Dialog parameter "Position" must have all positive elements.');
end

v = version;
if v(1) == '4'
property  = 'nextplot';
propvalue = 'add';
vs = 's';
else
property  = 'handlevisibility';
propvalue = 'callback';
vs = '';
end

fig = figure('NumberTitle','off','Name',DlgName,'Units',Units, ...
 'Pos',Position, ...
  property,propvalue , ...
  'Resize',Resize,'MenuBar','none', ...
 'Color',BackgroundColor,'UserData',UserData,'Vis','off');

UIPos = abs([0 mLineHeight+mOKButtonHeight FigWH(1) ...
 FigWH(2)-mLineHeight-mOKButtonHeight]);
uicontrol(fig,'Style','ed','Max',2,'String',TextString, ...
 'Pos',UIPos,'BackgroundColor',BackgroundColor, ...
 'ForegroundColor',ForegroundColor);
UIPos = abs([mEdgeToFrame            mEdgeToFrame ...
 FigWH(1)-2*mEdgeToFrame mLineHeight+mOKButtonHeight-2*mEdgeToFrame]);
uicontrol(fig,'Style','frame','BackgroundColor',BackgroundColor, ...
 'ForegroundColor',ForegroundColor,'Pos',UIPos);

div = Buttons+1;

UIPos = abs([FigWH(1)/div-StdButtonSize(1)/2 mLineHeight/2 StdButtonSize]);
YesPB = uicontrol(fig,'Style','push','String',Button1String, ...
 'BackgroundColor',BackgroundColor,'ForegroundColor',ForegroundColor, ...
 'Callback',Button1Call,...
 'Pos',UIPos);
pbs= [ YesPB ];

if Buttons>=2
   UIPos = abs([(div-1)*FigWH(1)/div-StdButtonSize(1)/2 mLineHeight/2 ...
    StdButtonSize]);
   CanPB = uicontrol(fig,'Style','push','String',Button2String, ...
    'BackgroundColor',BackgroundColor,'ForegroundColor',ForegroundColor, ...
    'Callback',Button2Call,...
    'Pos',UIPos);
    pbs=[ pbs CanPB ];
end
if Buttons>=3
   UIPos = abs([2*FigWH(1)/div-StdButtonSize(1)/2 mLineHeight/2 ...
    StdButtonSize]);
   NoPB = uicontrol(fig,'Style','push','String',Button3String, ...
    'BackgroundColor',BackgroundColor, ...
    'Callback',Button3Call,...
    'ForegroundColor',ForegroundColor,'Pos',UIPos);
    pbs=[ pbs NoPB ];
end

 set(get(fig,'Children'),'units','normalized');

% Only question dialog has more than one button
if strcmp(Style,'question'),

   % Remove all the callbacks & get ready to wait.
   set(pbs,'Callback','','Units','normalized');

   set(fig,'Vis','on');
   % An attempt at modality
   while ~any(get(fig,'CurrentO')==pbs), 
      drawnow
   end

   fig = get(get(fig,'CurrentO'),'Str');
   delete(gcf);

else

   % help, error, or warning dialog
   KeyPressFcn = ['if abs(get(' int2str(fig)  ...
    ',''CurrentChar''))==13, delete(gcf); end'];
   set(fig,'Vis','on','KeyPressFcn',KeyPressFcn);

end

% end dialog
