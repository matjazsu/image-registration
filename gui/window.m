function varargout = window(varargin)
% WINDOW MATLAB code for window.fig
%      WINDOW, by itself, creates a new WINDOW or raises the existing
%      singleton*.
%
%      H = WINDOW returns the handle to a new WINDOW or the handle to
%      the existing singleton*.
%
%      WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WINDOW.M with the given input arguments.
%
%      WINDOW('Property','Value',...) creates a new WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before window_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help window

% Last Modified by GUIDE v2.5 16-Jul-2017 18:34:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @window_OpeningFcn, ...
                   'gui_OutputFcn',  @window_OutputFcn, ...
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

% --- Executes just before window is made visible.
function window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to window (see VARARGIN)

% Choose default command line output for window
handles.output = hObject;

% reset controls
reset(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% ####################################################################################
% ####################################################################################

% #########
% Menu File
% #########

function m_File_Exit_Callback(hObject, eventdata, handles)

% exit
hf = findobj('Tag', 'window');
close(hf)

% ##########
% Menu Image
% ##########

% ########################################
% Menu Image - Load BrainWeb
% ########################################

function m_Image_LoadBrainWeb_Callback(hObject, eventdata, handles)

% load image
loadImage(hObject, handles, 'brainweb');

% ########################################
% Menu Image - Load RIRE
% ########################################

function m_Image_LoadRire_Callback(hObject, eventdata, handles)

% load image
loadImage(hObject, handles, 'rire');

% ########################################
% Menu Image - Load DICOM
% ########################################

function m_Image_LoadDicom_Callback(hObject, eventdata, handles)

% load image
loadImage(hObject, handles, 'dicom');

% ####################################################################################
% ####################################################################################

% ##############
% Menu Structure
% ##############

% ######################################
% Menu Structure - Load REG From Workspace
% ######################################

% --------------------------------------------------------------------
function m_Structure_LoadFromWS_Callback(hObject, eventdata, handles)

% reset controls
reset(hObject, handles);

% #################################
% Menu Structure - Save REG To File
% #################################

% --------------------------------------------------------------------
function m_Structure_SaveToFile_Callback(hObject, eventdata, handles)

global REG;

% Save REG structure to File
uisave('REG');

% #################################
% Menu Structure - Load REG From File
% #################################

% --------------------------------------------------------------------
function m_Structure_LoadFromFile_Callback(hObject, eventdata, handles)

global REG;

% read input
[File_Name, File_Path] = uigetfile('~/*.mat', 'Pick a file...');

% input validation
if isequal(File_Name, 0) || isequal(File_Path, 0)
    return;
end

% update REG from file
FREG = load(strcat(File_Path, File_Name), '-mat');
if isempty(FREG.REG)
    return;
end

REG = FREG.REG;

% reset controls
reset(hObject, handles);

% ####################################################################################
% ####################################################################################

% ##############
% Menu Registration
% ##############

% #################################
% Menu Registration - Load Registration Procedure
% #################################

% --------------------------------------------------------------------
function m_Registration_Select_Callback(hObject, eventdata, handles)

global GUI;

if isempty(GUI.internal.tools.path) || isempty(GUI.internal.tools.selector.name)
    return;
end

% execute
run(fullfile(GUI.internal.tools.path, GUI.internal.tools.selector.name));

% update external script text
set(handles.m_txtRegProcedure, 'String', GUI.external.name);

% ####################################################################################
% ####################################################################################

% FUNCTIONALITY

% ####################################################################################
% ####################################################################################

% ###########
% Reference Image
% ###########

% ###########################
% Slider (Reference Image)
% ###########################

% --- Executes on slider movement.
function m_slRefImg_Callback(hObject, eventdata, handles)

renderRefImage(handles);

function m_txtCurrSliceRefImg_Callback(hObject, eventdata, handles)

% get sliceNumber
sliceNumber = get(handles.m_txtCurrSliceRefImg, 'String');
if isempty(sliceNumber)
    return;
end

sliceNumber = str2double(sliceNumber);
if isempty(sliceNumber) || isnan(sliceNumber)
    return;
end

% set slider value
set(handles.m_slRefImg, 'Value', sliceNumber);

% render reference image
renderRefImage(handles);

% #########################
% Pop-Up menu (Reference Image)
% #########################

% --- Executes on selection change in m_popRefImg.
function m_popRefImg_Callback(hObject, eventdata, handles)

global REG;

contents = cellstr(get(hObject,'String'));
REG.refIdx = int32(str2num(contents{get(hObject,'Value')}));

% render image
renderRefImage(handles);

% ####################################################################################
% ####################################################################################

% ############
% Moving Image
% ############

% #####################
% Slider (Moving Image)
% #####################

% --- Executes on slider movement.
function m_slMovImg_Callback(hObject, eventdata, handles)

renderMovImage(handles);

function m_txtCurrSliceMovImg_Callback(hObject, eventdata, handles)

% get sliceNumber
sliceNumber = get(handles.m_txtCurrSliceMovImg, 'String');
if isempty(sliceNumber)
    return;
end

sliceNumber = str2double(sliceNumber);
if isempty(sliceNumber) || isnan(sliceNumber)
    return;
end

% set slider value
set(handles.m_slMovImg, 'Value', sliceNumber);

% render reference image
renderMovImage(handles);

% ##########################
% Pop-Up menu (Moving Image)
% ##########################

% --- Executes on selection change in m_popMovImg.
function m_popMovImg_Callback(hObject, eventdata, handles)

global REG;

contents = cellstr(get(hObject,'String'));
REG.movIdx = int32(str2num(contents{get(hObject,'Value')}));

% render images
renderMovImage(handles);

% ####################################################################################
% ####################################################################################

% ##########################
% Reference Image Tools
% ##########################

% --- Executes on button press in m_btnShowRefHist.
function m_btnShowRefHist_Callback(hObject, eventdata, handles)

global REG;

% validation
    
if isempty(REG)
    return;
end

if isempty(REG.img)
    return;
end

% get reference image
image = REG.img(REG.refIdx).data;
if ~isempty(REG.img(REG.refIdx).data_resample)
    image = REG.img(REG.refIdx).data_resample;
end

% ROI processing
if ~isempty(REG.img(REG.refIdx).ROI)
    roi = REG.img(REG.refIdx).ROI;
    image = image(roi(1):roi(2), roi(3):roi(4), :);
end

figure('name', 'Histogram - Ref. Image', 'numbertitle','off');
H = imhist(image(:), 256);
bar(H);

% --- Executes on button press in m_btnSetRefROI.
function m_btnSetRefROI_Callback(hObject, eventdata, handles)

global REG;

disableControls(handles);

waitforbuttonpress;

% button down detected
point1 = get(gca,'CurrentPoint');    
% return figure units
rbbox;                               
% button up detected
point2 = get(gca,'CurrentPoint');    

% extract x
point1 = point1(1,1:2);              
% extract y
point2 = point2(1,1:2);              

% calculate locations/dimensions
p1 = min(point1,point2);
offset = abs(point1-point2);         

x = round([p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)]);
y = round([p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)]);

% read image size
I_size = size(REG.img(REG.refIdx).data);

% set ROI
REG.img(REG.refIdx).ROI = [int32(y(1)) int32(y(3)) int32(x(1)) int32(x(2)) 1 int32(I_size(3))];

% render images
renderRefImage(handles);

enableControls(handles);

% --- Executes on button press in m_btnRemoveRefROI.
function m_btnRemoveRefROI_Callback(hObject, eventdata, handles)

global REG;

set(handles.m_btnRemoveRefROI, 'Enable', 'off');

% remove ROI
REG.img(REG.refIdx).ROI = [];

% render images
renderRefImage(handles);

set(handles.m_btnRemoveRefROI, 'Enable', 'on');

% ####################################################################################
% ####################################################################################

% ##########################
% Moving Image Tools
% ##########################

% --- Executes on button press in m_btnShowMovHist.
function m_btnShowMovHist_Callback(hObject, eventdata, handles)

global REG;

% validation
    
if isempty(REG)
    return;
end

if isempty(REG.img)
    return;
end

% get moving image
image = REG.img(REG.movIdx).data;
if ~isempty(REG.img(REG.movIdx).data_resample)
    image = REG.img(REG.movIdx).data_resample;
end

% ROI processing
if ~isempty(REG.img(REG.movIdx).ROI)
    roi = REG.img(REG.movIdx).ROI;
    image = image(roi(1):roi(2), roi(3):roi(4), :);
end

figure('name', 'Histogram - Mov. Image', 'numbertitle','off');
H = imhist(image(:), 256);
bar(H);

% --- Executes on button press in m_btnSetMovROI.
function m_btnSetMovROI_Callback(hObject, eventdata, handles)

global REG;

disableControls(handles);

waitforbuttonpress;

% button down detected
point1 = get(gca,'CurrentPoint');    
% return figure units
rbbox;                               
% button up detected
point2 = get(gca,'CurrentPoint');    

% extract x
point1 = point1(1,1:2);              
% extract y
point2 = point2(1,1:2);              

% calculate locations/dimensions
p1 = min(point1,point2);
offset = abs(point1-point2);         

x = round([p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)]);
y = round([p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)]);

% read image size
I_size = size(REG.img(REG.movIdx).data);

% set ROI
REG.img(REG.movIdx).ROI = [int32(y(1)) int32(y(3)) int32(x(1)) int32(x(2)) 1 int32(I_size(3))];

% render images
renderMovImage(handles);

enableControls(handles);

% --- Executes on button press in m_btnRemoveMovROI.
function m_btnRemoveMovROI_Callback(hObject, eventdata, handles)

global REG;

set(handles.m_btnRemoveMovROI, 'Enable', 'off');

% remove ROI
REG.img(REG.movIdx).ROI = [];

% render images
renderMovImage(handles);

set(handles.m_btnRemoveMovROI, 'Enable', 'on');

% ####################################################################################
% ####################################################################################

% ##########################
% Registration Tools
% ##########################

% --- Executes on button press in m_btnRunRegProcedure.
function m_btnRunRegProcedure_Callback(hObject, eventdata, handles)

global GUI;

if isempty(GUI.external.path) || isempty(GUI.external.name)
    return;
end

disableControls(handles);

try
    % set path
    addpath(genpath(GUI.external.path));
    % execute 
    run(fullfile(GUI.external.path, GUI.external.name));
    % render images
    renderRefImage(handles);
    renderMovImage(handles);
    % display success
    display('REGISTRATION PROCEDURE HAS FINISHED SUCCESSFULLY...');
    uiwait(msgbox('REGISTRATION PROCEDURE HAS FINISHED SUCCESSFULLY...', '', 'modal'));
catch ME
    display(ME);
    enableControls(handles);
    display('REGISTRATION PROCEDURE HAS FINISHED WITH ERRORS...');
    uiwait(msgbox(ME.message, '', 'modal'));
end

enableControls(handles);

% --- Executes on button press in m_btnUnload.
function m_btnUnload_Callback(hObject, eventdata, handles)

global GUI;

GUI.external.name = '';

% update text
set(handles.m_txtRegProcedure, 'String', GUI.external.name);

% --- Executes on button press in m_btnApplyTransformation.
function m_btnApplyTransformation_Callback(hObject, eventdata, handles)

global GUI;

if isempty(GUI.internal.tools.path) || isempty(GUI.internal.tools.transform.name)
    return;
end

disableControls(handles);

try
    % execute 
    run(fullfile(GUI.internal.tools.path, GUI.internal.tools.transform.name));
    % render images
    renderMovImage(handles);
catch ME
    display(ME);
    uiwait(msgbox(ME.message, '', 'modal'));
end

enableControls(handles);

% --- Executes on button press in m_btnRemoveTransformation.
function m_btnRemoveTransformation_Callback(hObject, eventdata, handles)

global REG;

% validate img
if isempty(REG.img)
    return;
end

% validation img length
if length(REG.img) < REG.movIdx
    return;
end

% remove transformation
REG.img(REG.movIdx).data_resample = [];

% render images
renderMovImage(handles);

% --- Executes on button press in m_btnShowJointHist.
function m_btnShowJointHist_Callback(hObject, eventdata, handles)

global GUI;
global REG;

if isempty(GUI.internal.tools.path) || isempty(GUI.internal.tools.joint_histogram.name)
    return;
end

set(handles.m_btnShowJointHist, 'Enable', 'off');

try
    % evaluate registration results
    T=REG.img(REG.movIdx).T;
    D=REG.img(REG.movIdx).D;
    if isempty(REG.img(REG.movIdx).data_resample)
        REG.img(REG.movIdx).T=[];
        REG.img(REG.movIdx).D=[];
    end
    
    % execute 
    run(fullfile(GUI.internal.tools.path, GUI.internal.tools.joint_histogram.name));

    % reset registration results
    REG.img(REG.movIdx).T=T;
    REG.img(REG.movIdx).D=D;
catch ME
    display(ME);
end

set(handles.m_btnShowJointHist, 'Enable', 'on');

% --- Executes on button press in m_btnShowDifference.
function m_btnShowDifference_Callback(hObject, eventdata, handles)

global GUI;
global REG;

if isempty(GUI.internal.tools.path) || isempty(GUI.internal.tools.difference.name)
    return;
end

set(handles.m_btnShowDifference, 'Enable', 'off');

try
    % evaluate registration results
    T=REG.img(REG.movIdx).T;
    D=REG.img(REG.movIdx).D;
    if isempty(REG.img(REG.movIdx).data_resample)
        REG.img(REG.movIdx).T=[];
        REG.img(REG.movIdx).D=[];
    end
    
    % execute 
    run(fullfile(GUI.internal.tools.path, GUI.internal.tools.difference.name));
    
    % reset registration results
    REG.img(REG.movIdx).T=T;
    REG.img(REG.movIdx).D=D;
catch ME
    display(ME);
end

set(handles.m_btnShowDifference, 'Enable', 'on');

% --- Executes on button press in m_btnShowCheckerboard.
function m_btnShowCheckerboard_Callback(hObject, eventdata, handles)

global GUI;
global REG;

if isempty(GUI.internal.tools.path) || isempty(GUI.internal.tools.checkerboard.name)
    return;
end

set(handles.m_btnShowCheckerboard, 'Enable', 'off');

try
    % evaluate registration results
    T=REG.img(REG.movIdx).T;
    D=REG.img(REG.movIdx).D;
    if isempty(REG.img(REG.movIdx).data_resample)
        REG.img(REG.movIdx).T=[];
        REG.img(REG.movIdx).D=[];
    end
    
    % execute 
    run(fullfile(GUI.internal.tools.path, GUI.internal.tools.checkerboard.name));
    
    % reset registration results
    REG.img(REG.movIdx).T=T;
    REG.img(REG.movIdx).D=D;
catch ME
    display(ME);
end

set(handles.m_btnShowCheckerboard, 'Enable', 'on');

% ####################################################################################
% ####################################################################################

% ##########################
% Helper functions
% ##########################

function reset(hObject, handles)

global REG;
global GUI;

if isempty(REG) || isempty(GUI)
    return;
end

if ~isempty(REG.img)    
    % init imagesIdx
    for index=1:length(REG.img)
        handles.imagesIdx{index} = index;
    end
    
    renderRefImage(handles);
    renderMovImage(handles);
    updatePopUpMenus(handles);
else
    % override REG
    REG.refIdx = int32(1);
    REG.movIdx = int32(1);
    
    % init imagesIdx
    handles.imagesIdx{1} = REG.refIdx;
    
    updatePopUpMenus(handles);
end

% update external script text
set(handles.m_txtRegProcedure, 'String', GUI.external.name);

% update guidata
guidata(hObject, handles);

function loadImage(hObject, handles, type)

global REG;
global GUI;

if isequal(type, 'brainweb')
    run(fullfile(GUI.internal.images.path, GUI.internal.images.brainweb.name));
elseif isequal(type, 'rire')
    run(fullfile(GUI.internal.images.path, GUI.internal.images.rire.name));
elseif isequal(type, 'dicom')
    run(fullfile(GUI.internal.images.path, GUI.internal.images.dicom.name));
end

% update imagesIdx
handles.imagesIdx{REG.movIdx} = REG.movIdx;

renderRefImage(handles);
renderMovImage(handles);
updatePopUpMenus(handles);

% update guidata
guidata(hObject, handles);

function renderRefImage (handles)

global REG;

% validate img
if isempty(REG.img)
    return;
end

% validation img length
if length(REG.img) < REG.refIdx
    return;
end

% get image data
image = REG.img(REG.refIdx).data;
if ~isempty(REG.img(REG.refIdx).data_resample)
    image = REG.img(REG.refIdx).data_resample;
end

% read image size
image_size = size(image);

% image name
set(handles.m_txtRefImgName, 'String', REG.img(REG.refIdx).name);

% slider value
sliderValue = int32(get(handles.m_slRefImg, 'Value'));
if sliderValue <= 0 || sliderValue > image_size(3)
    sliderValue = 1;
end

% slider configuration
maxNumberOfSlices = image_size(3);
set(handles.m_slRefImg, 'Min', 1);
set(handles.m_slRefImg, 'Max', maxNumberOfSlices);
set(handles.m_slRefImg, 'Value', sliderValue);
set(handles.m_slRefImg, 'SliderStep', [1/maxNumberOfSlices , 10/maxNumberOfSlices]);

% slice number
set(handles.m_txtCurrSliceRefImg,'String',sliderValue);
set(handles.m_txtSliceRefImg, 'String', image_size(3));

% copy data
image_copy = image;

% ROI processing
if ~isempty(REG.img(REG.refIdx).ROI)
    roi = REG.img(REG.refIdx).ROI;
    roi_copy = image_copy(roi(1):roi(2), roi(3):roi(4), :);
    roi_copy = (70 + roi_copy);
    image_copy(roi(1):roi(2), roi(3):roi(4), :) = roi_copy;
end

% axes
axes(handles.m_axesRefImg);
imagesc(image_copy(:,:,sliderValue)); colormap gray; 
set(handles.m_axesRefImg,'XTick',[]);
set(handles.m_axesRefImg,'YTick',[]);

function renderMovImage(handles)

global REG;

% validate img
if isempty(REG.img)
    return;
end

% validation img length
if length(REG.img) < REG.movIdx
    return;
end

% get image data
image = REG.img(REG.movIdx).data;
if ~isempty(REG.img(REG.movIdx).data_resample)
    image = REG.img(REG.movIdx).data_resample;
end

% read image size
image_size = size(image);

% image name
set(handles.m_txtMovImgName, 'String', REG.img(REG.movIdx).name);

% slider value
sliderValue = int32(get(handles.m_slMovImg, 'Value'));
if sliderValue <= 0 || sliderValue > image_size(3)
    sliderValue = 1;
end

% slider configuration
maxNumberOfSlices = image_size(3);
set(handles.m_slMovImg, 'Min', 1);
set(handles.m_slMovImg, 'Max', maxNumberOfSlices);
set(handles.m_slMovImg, 'Value', sliderValue);
set(handles.m_slMovImg, 'SliderStep', [1/maxNumberOfSlices , 10/maxNumberOfSlices ]);

% slice number
set(handles.m_txtCurrSliceMovImg,'String',sliderValue);
set(handles.m_txtSliceMovImg, 'String', image_size(3));

% copy data
image_copy = image;

% ROI processing
if ~isempty(REG.img(REG.movIdx).ROI)
    roi = REG.img(REG.movIdx).ROI;
    roi_copy = image_copy(roi(1):roi(2), roi(3):roi(4), :);
    roi_copy = (70 + roi_copy);
    image_copy(roi(1):roi(2), roi(3):roi(4), :) = roi_copy;
end

% axes
axes(handles.m_axesMovImg);
imagesc(image_copy(:,:,sliderValue)); colormap gray; 
set(handles.m_axesMovImg,'XTick',[]);
set(handles.m_axesMovImg,'YTick',[]);

function updatePopUpMenus(handles)

global REG;

% update m_popRefImg
set(handles.m_popRefImg, 'String', handles.imagesIdx);
set(handles.m_popRefImg, 'Value', REG.refIdx);

% update m_popMovImg
set(handles.m_popMovImg, 'String', handles.imagesIdx);
set(handles.m_popMovImg, 'Value', REG.movIdx);

function disableControls(handles)

set(findall(handles.m_panRefImgTools, '-property', 'Enable'), 'Enable', 'off');
set(findall(handles.m_panRegTools, '-property', 'Enable'), 'Enable', 'off');
set(findall(handles.m_panMovImgTools, '-property', 'Enable'), 'Enable', 'off');

drawnow; pause(0.1);

function enableControls(handles)

set(findall(handles.m_panRefImgTools, '-property', 'Enable'), 'Enable', 'on');
set(findall(handles.m_panRegTools, '-property', 'Enable'), 'Enable', 'on');
set(findall(handles.m_panMovImgTools, '-property', 'Enable'), 'Enable', 'on');

drawnow; pause(0.1);
