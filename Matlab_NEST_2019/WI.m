function WI(block)
% Level-2 M file S-Function for interface demo.
%   Copyright 1990-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $ 

  setup(block);
  
%endfunction

function setup(block)
  global nestbutton
  global rotational
  
  %% Register dialog parameters: No parameters for this block 
  block.NumDialogPrms = 0;
  %% Register number of input and output ports
  block.NumInputPorts  = 4;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;                    % port inherits sample rates

  %% Input 1 is for central big text
  block.InputPort(1).Complexity   = 'Real'; 
  block.InputPort(1).DataTypeId   = 4;                     % 8 for boolean, 0 for double, 3 for uint8 4 for int8
  block.InputPort(1).SamplingMode = 'Sample';
  block.InputPort(1).Dimensions   = 1;
  block.InputPort(1).DirectFeedthrough   = 0;

  %% Input 2 is for central mode/status string
  block.InputPort(2).Complexity   = 'Real'; 
  block.InputPort(2).DataTypeId   = 3;                     % 8 for boolean, 0 for double, 3 for uint8 4 for int8
  block.InputPort(2).SamplingMode = 'Sample';
  block.InputPort(2).Dimensions   = 1;
  block.InputPort(2).DirectFeedthrough   = 0;

  %% Input 3 is for central upper small text
  block.InputPort(3).Complexity   = 'Real'; 
  block.InputPort(3).DataTypeId   = 4;                     % 8 for boolean, 0 for double, 3 for uint8 4 for int8
  block.InputPort(3).SamplingMode = 'Sample';
  block.InputPort(3).Dimensions   = 1;
  block.InputPort(3).DirectFeedthrough   = 0;

  %% Input 4 is for lower icon
  block.InputPort(4).Complexity   = 'Real'; 
  block.InputPort(4).DataTypeId   = 8;                     % 8 for boolean, 0 for double, 3 for uint8 4 for int8
  block.InputPort(4).SamplingMode = 'Sample';
  block.InputPort(4).Dimensions   = 1;
  block.InputPort(4).DirectFeedthrough   = 0;
  
  block.NumOutputPorts = 2;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompOutPortInfoToDynamic;

  %% LCD Central region press

  block.OutputPort(1).Complexity   = 'Real'; 
  block.OutputPort(1).DataTypeId   = 8;                     % 8 for boolean, 0 for double, 3 for uint8 4 for int8
  block.OutputPort(1).SamplingMode = 'Sample';
  block.OutputPort(1).Dimensions   = 1;

  %% Rotational position

  block.OutputPort(2).Complexity   = 'Real'; 
  block.OutputPort(2).DataTypeId   = SS_INT16;                     % 8 for boolean, 0 for double, 3 for uint8 4 for int8
  block.OutputPort(2).SamplingMode = 'Sample';
  block.OutputPort(2).Dimensions   = 1;

 


  %% Register methods
  block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
  block.RegBlockMethod('Start',                   @Start);  
  %   block.RegBlockMethod('WriteRTW',                @WriteRTW);
  block.RegBlockMethod('Outputs',                 @Outputs);

  nestbutton = 0;
  rotational = 0;
 
  %endfunction

 function SetInputPortSamplingMode(block, idx, fd)
   block.InputPort(idx).SamplingMode = fd;

function ButtonDown(hObj,evnt)
  global nestbutton
  global rotational 

  pos = get(hObj,'CurrentPoint');

  if ((pos(2) > 240-(188+41)) && (pos(2) < 240-188) && (pos(1) > 25) && (pos(1) < (25+44)))
            nestbutton=1;
  end;

function ButtonUp(hObj,evnt)
  global nestbutton
  global rotational  

  pos = get(hObj,'CurrentPoint');

  if ((pos(2) > 240-(188+41)) && (pos(2) < 240-188) && (pos(1) > 25) && (pos(1) < (25+44)))
            nestbutton=0;
  end;

function Start(block) 

  global IMBG
  global leafblkicon

  global leaftblkicon_hnd;
  
  global centralTxt;
  global statusTxT;
  global upperTxt;
 

  IMBG = imread('images/nest_bg_black.png');
  leafblkicon = imread('images/leaf_black.png');

  bhD = @ButtonDown;
  bhU = @ButtonUp;

% background image 

  FH = figure('Toolbar', 'none', 'Menubar', 'none', 'Name', 'Figname', 'WindowButtonDownFcn', bhD, 'WindowButtonUpFcn', bhU, 'Resize', 'off');
  scrsz = get(0,'ScreenSize');
  set(FH, 'Units','pixels');
  set(FH, 'Position',[1 scrsz(4)-500 320 240]);
  hax = axes('Units', 'pixels', 'Position', [1, 1, 320, 240], 'Visible', 'off');
  image(IMBG)
  axis off

% text output 

% skipping Arial
  centralTxt = text(33, 240-68,'', 'Units', 'pixels', 'FontUnits', 'points', 'FontSize', 32);
  set(hrs_digits, 'Color',[1 1 1]);
  set(hrs_digits, 'VerticalAlignment','top');
  set(hrs_digits, 'FontName', 'Arial');

  statusTxT = text(89, 240-68,'', 'Units', 'pixels', 'FontUnits', 'points', 'FontSize', 32);
  set(min_digits, 'Color',[1 1 1]);
  set(min_digits, 'VerticalAlignment','top');
  set(min_digits, 'FontName', 'Arial');

  upperTxt = text(145, 240-68,'', 'Units', 'pixels', 'FontUnits', 'points', 'FontSize', 32);
  set(sec_digits, 'Color',[1 1 1]);
  set(sec_digits, 'VerticalAlignment','top');
  set(sec_digits, 'FontName', 'Arial');

  hax = axes('Units', 'pixels', 'Position', [30, 240-188-43, 39, 43], 'Visible', 'off');
  leaftblkicon_hnd = image(leafblkicon, 'Visible', 'on');
  axis off;

%endfunction

function con_str = convertDto2S(dig)
  shw_val = mod(dig, 100);
  con_str = int2str(shw_val);
  if shw_val < 10 
      con_str = strcat('0',con_str);
  end
%endfunction

function con_str = convertDto1S(dig)
  shw_val = mod(dig, 10);
  con_str = int2str(shw_val);
%endfunction

    function Outputs(block)
  
  global IMBG
  global leafblkicon

  global leaftblkicon_hnd;
  
  global centralTxt;
  global statusTxT;
  global upperTxt;
 
%Update graphics based on input ports

%% Need to transform block.InputPort(1).Data value into string of 2 chars
  set(centralTxt, 'string',  convertDto2S(block.InputPort(1).Data))
%% Need to transform block.InputPort(2).Data value into string of 2 chars
  set(statusTxT, 'string', convertDto2S(block.InputPort(2).Data))
%% Need to transform block.InputPort(2).Data value into string of 2 chars
  set(statusTxT, 'string', convertDto2S(block.InputPort(2).Data))
  
  if block.InputPort(4).Data == 1 
      set(leaftblkicon_hnd, 'Visible', 'on')
  else
      set(leaftblkicon_hnd, 'Visible', 'off')
  end;

 
%Update output ports

  block.OutputPort(1).Data = boolean(nestbutton);   % 8 for boolean, 0 for double, 3 for uint8 4 for int8
  block.OutputPort(2).Data = int16(rotational);   % 8 for boolean, 0 for double, 3 for uint8 4 for int8
    
%endfunction

