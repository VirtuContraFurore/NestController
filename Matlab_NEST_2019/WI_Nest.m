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
  block.NumInputPorts  = 5;

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
  
  %% Input 5 is for mode
  block.InputPort(5).Complexity   = 'Real'; 
  block.InputPort(5).DataTypeId   = 3;                     % 8 for boolean, 0 for double, 3 for uint8 4 for int8
  block.InputPort(5).SamplingMode = 'Sample';
  block.InputPort(5).Dimensions   = 1;
  block.InputPort(5).DirectFeedthrough   = 0;

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
  block.OutputPort(2).DataTypeId   = 5;                     % 8 for boolean, 0 for double, 3 for uint8 4 for int8
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

  if ((pos(2) > 50) && (pos(2) < 190) && (pos(1) > 90) && (pos(1) < 225))
            nestbutton=1;
  end

function ButtonUp(hObj,evnt)
  global nestbutton
  global rotational  

  pos = get(hObj,'CurrentPoint');

  if ((pos(2) > 50) && (pos(2) < 190) && (pos(1) > 90) && (pos(1) < 225))
            nestbutton=0;
  end

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
  centralTxt = text(124, 140,'', 'Units', 'pixels', 'FontUnits', 'points', 'FontSize', 54);
  set(centralTxt, 'Color',[1 1 1]);
  set(centralTxt, 'VerticalAlignment','top');
  set(centralTxt, 'FontName', 'Arial');

  statusTxT = text(120, 160,'', 'Units', 'pixels', 'FontUnits', 'points', 'FontSize', 16);
  set(statusTxT, 'Color',[1 1 1]);
  set(statusTxT, 'VerticalAlignment','top');
  set(statusTxT, 'FontName', 'Arial');

  upperTxt = text(144, 190,'', 'Units', 'pixels', 'FontUnits', 'points', 'FontSize', 20);
  set(upperTxt, 'Color',[1 1 1]);
  set(upperTxt, 'VerticalAlignment','top');
  set(upperTxt, 'FontName', 'Arial');

  hax = axes('Units', 'pixels', 'Position', [150, 40, 17, 15], 'Visible', 'off');
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
  
  global nestbutton
  global rotational

  global leaftblkicon_hnd;
  
  global centralTxt;
  global statusTxT;
  global upperTxt;
 
%Update graphics based on input ports

%% Need to transform block.InputPort(1).Data value into string of 2 chars
  if block.InputPort(5).Data/100 == 1
      set(centralTxt, 'string', "--")
  else
      if block.InputPort(5).Data == 0
          set(centralTxt, 'Color',  [1 1 1])
      end
      if block.InputPort(5).Data == 1
          set(centralTxt, 'Color',  [0.3 0.3 1])
      end
      if block.InputPort(5).Data == 2
          set(centralTxt, 'Color',  [1 0.2 0])
      end
      set(centralTxt, 'string',  convertDto2S(block.InputPort(1).Data/10))
  end
      
%% Need to transform block.InputPort(2).Data value into string of 2 chars
  set(statusTxT, 'string', 'test')
%% Need to transform block.InputPort(2).Data value into string of 2 chars
  set(upperTxt, 'string', convertDto2S(block.InputPort(3).Data/10))
  
  if block.InputPort(4).Data == 1 
      set(leaftblkicon_hnd, 'Visible', 'on')
  else
      set(leaftblkicon_hnd, 'Visible', 'off')
  end

 
%Update output ports

  block.OutputPort(1).Data = boolean(nestbutton);   % 8 for boolean, 0 for double, 3 for uint8 4 for int8
  block.OutputPort(2).Data = uint16(rotational);   % 8 for boolean, 0 for double, 3 for uint8 4 for int8
    
%endfunction

