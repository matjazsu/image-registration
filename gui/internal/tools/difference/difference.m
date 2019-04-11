function varargout = difference(varargin)
% DIFFERENCE MATLAB code for difference.fig
%      DIFFERENCE, by itself, creates a new DIFFERENCE or raises the existing
%      singleton*.
%
%      H = DIFFERENCE returns the handle to a new DIFFERENCE or the handle to
%      the existing singleton*.
%
%      DIFFERENCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIFFERENCE.M with the given input arguments.
%
%      DIFFERENCE('Property','Value',...) creates a new DIFFERENCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before difference_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to difference_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help difference

% Last Modified by GUIDE v2.5 16-Jul-2017 18:58:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @difference_OpeningFcn, ...
                   'gui_OutputFcn',  @difference_OutputFcn, ...
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

% --- Executes just before difference is made visible.
function difference_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to difference (see VARARGIN)

% Choose default command line output for difference
handles.output = hObject;

% reset controls
reset(hObject, handles);

% UIWAIT makes difference wait for user response (see UIRESUME)
% uiwait(handles.difference);


% --- Outputs from this function are returned to the command line.
function varargout = difference_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% ####################################################################################
% ####################################################################################

% #####################
% Slider 
% #####################

% --- Executes on slider movement.
function m_slider_Callback(hObject, eventdata, handles)

% render image
render(handles);

% ####################################################################################
% ####################################################################################

% #####################
% CurrSlice Callback 
% #####################

function m_txtCurrSlice_Callback(hObject, eventdata, handles)

% get sliceNumber
sliceNumber = get(handles.m_txtCurrSlice, 'String');
if isempty(sliceNumber)
    return;
end

sliceNumber = str2double(sliceNumber);
if isempty(sliceNumber) || isnan(sliceNumber)
    return;
end

% set slider value
set(handles.m_slider, 'Value', sliceNumber);

% render image
render(handles);

% ####################################################################################
% ####################################################################################

% ##########################
% Helper functions
% ##########################

function reset(hObject, handles)

global REG;

% validation
if isempty(REG) || isempty(REG.img)
    return;
end

% validation
if isempty(REG.img(REG.refIdx))
    return;
end

% validation
if isempty(REG.img(REG.movIdx))
    return;
end

% get reference image data
R = REG.img(REG.refIdx).data;

T = REG.img(REG.movIdx).T;
D = REG.img(REG.movIdx).D;
if isempty(REG.img(REG.movIdx).data_resample)
    REG.img(REG.movIdx).T = [];
    REG.img(REG.movIdx).D = [];
end

% resample the moving image to the 
% space of the reference image
M = resampleMov2Ref_(REG);

REG.img(REG.movIdx).T = T;
REG.img(REG.movIdx).D = D;

% calculate the absolute difference
handles.difference = imabsdiff(R, M);

% render image
render(handles);

% update guidata
guidata(hObject, handles);

function render(handles)

if isempty(handles.difference)
    return;
end

% read image size
image_size = size(handles.difference);

% slider value
sliderValue = int32(get(handles.m_slider, 'Value'));
if sliderValue <= 0 || sliderValue > image_size(3)
    sliderValue = 1;
end

% slider configuration
maxNumberOfSlices = image_size(3);
set(handles.m_slider, 'Min', 1);
set(handles.m_slider, 'Max', maxNumberOfSlices);
set(handles.m_slider, 'Value', sliderValue);
set(handles.m_slider, 'SliderStep', [1/maxNumberOfSlices , 10/maxNumberOfSlices]);

% slice number
set(handles.m_txtCurrSlice, 'String',sliderValue);
set(handles.m_txtSlice, 'String', image_size(3));

% axes
axes(handles.m_axes);
imagesc(handles.difference(:,:,sliderValue)); colormap gray; 
set(handles.m_axes,'XTick',[]);
set(handles.m_axes,'YTick',[]);
