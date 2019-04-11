function varargout = selector(varargin)
% SELECTOR MATLAB code for selector.fig
%      SELECTOR, by itself, creates a new SELECTOR or raises the existing
%      singleton*.
%
%      H = SELECTOR returns the handle to a new SELECTOR or the handle to
%      the existing singleton*.
%
%      SELECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTOR.M with the given input arguments.
%
%      SELECTOR('Property','Value',...) creates a new SELECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selector

% Last Modified by GUIDE v2.5 09-Apr-2017 19:19:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selector_OpeningFcn, ...
                   'gui_OutputFcn',  @selector_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before selector is made visible.
function selector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selector (see VARARGIN)

% Choose default command line output for SELECTOR
handles.output = hObject;

% reset controls
reset(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = selector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in m_btnSelect.
function m_btnSelect_Callback(hObject, eventdata, handles)

% exit
hf = findobj('Tag', 'selector');
close(hf)

% --- Executes on button press in m_btnCancel.
function m_btnCancel_Callback(hObject, eventdata, handles)

global GUI;

% set external file name
GUI.external.name = '';

% exit
hf = findobj('Tag', 'selector');
close(hf)

% --- Executes on selection change in m_lstFiles.
function m_lstFiles_Callback(hObject, eventdata, handles)

global GUI;

% get selected file
contents = cellstr(get(hObject, 'String'));
if isempty(contents)
    return;
end

% set external file name
GUI.external.name = contents{get(hObject, 'Value')};

% ##########################
% Helper functions
% ##########################

function reset(hObject, handles)

global GUI;
    
% read dir
content = dir(GUI.external.path);
numContent = size(content, 1);

fileIdx = 1;
files = {};
    
% init files
for i = 1 : numContent
    if content(i).isdir==1 
        continue;
    end
    if ~isempty(strfind(content(i).name,'.m'))
       files{fileIdx} = content(i).name; 
       fileIdx = fileIdx + 1;
    end
end

% update gui control
set(handles.m_lstFiles, 'String', files);

% Update handles structure
guidata(hObject, handles);
