function varargout = points(varargin)
% POINTS MATLAB code for points.fig
%      POINTS, by itself, creates a new POINTS or raises the existing
%      singleton*.
%
%      H = POINTS returns the handle to a new POINTS or the handle to
%      the existing singleton*.
%
%      POINTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POINTS.M with the given input arguments.
%
%      POINTS('Property','Value',...) creates a new POINTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before points_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to points_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help points

% Last Modified by GUIDE v2.5 27-May-2018 16:14:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @points_OpeningFcn, ...
                   'gui_OutputFcn',  @points_OutputFcn, ...
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

% --- Executes just before points is made visible.
function points_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to points (see VARARGIN)

% Choose default command line output for points
handles.output = hObject;

% reset controls
reset(hObject, handles, varargin);

% UIWAIT makes points wait for user response (see UIRESUME)
% uiwait(handles.points);


% --- Outputs from this function are returned to the command line.
function varargout = points_OutputFcn(hObject, eventdata, handles) 
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

function reset(hObject, handles, varargin)

% validation
if isempty(varargin)
    return;
end

% validation
if isempty(varargin(1))
    return;
end

O_grid=cell2mat(varargin{1}(1));
sizes=cell2mat(varargin{1}(2));
Spacing=cell2mat(varargin{1}(3));

% calculate the bspline control points grid image
I_grid = make_grid_image(Spacing, sizes);
I_grid = bspline_transform(O_grid, Spacing, I_grid);
handles.points = I_grid;

% render image
render(handles);

% update guidata
guidata(hObject, handles);

function render(handles)

if isempty(handles.points)
    return;
end

% read image size
image_size = size(handles.points);

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
imagesc(handles.points(:,:,sliderValue)); colormap gray; 
set(handles.m_axes,'XTick',[]);
set(handles.m_axes,'YTick',[]);
