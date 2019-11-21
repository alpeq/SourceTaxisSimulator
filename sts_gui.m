function varargout = sts_gui(varargin)
% STS_GUI MATLAB code for sts_gui.fig
%      STS_GUI, by itself, creates a new STS_GUI or raises the existing
%      singleton*.
%
%      H = STS_GUI returns the handle to a new STS_GUI or the handle to
%      the existing singleton*.
%
%      STS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STS_GUI.M with the given input arguments.
%
%      STS_GUI('Property','Value',...) creates a new STS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sts_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sts_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sts_gui

% Last Modified by GUIDE v2.5 15-Nov-2019 09:46:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sts_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @sts_gui_OutputFcn, ...
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



% --- Executes just before sts_gui is made visible.
function sts_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sts_gui (see VARARGIN)

global CONFIG
warning('off','all');





% Save the handle of the axis in the guidata
axesSimula = findobj('Tag', 'simula');
handles.axesHandle = axesSimula;

axesModel = findobj('Tag', 'modelpic');
handles.axesModel = axesModel;

axesEqu = findobj('Tag', 'modelequ');
handles.axesEqu = axesEqu;

% plot in init a presentation image from inkscape with title of the app.
imtitle = imread('titleapp.png'); %flip 
immodel = imread('3braitenberg.png'); %flip 
imequ = imread('3braitenberg_equ.png'); %flip

axes(handles.axesHandle);
imshow(imtitle);

axes(handles.axesModel);
imshow(immodel);

axes(handles.axesEqu);
imshow(imequ);

%plot( axesSimula, 1:10,-1:-1:-10)
handles.simula_pHand = [];
% Choose default command line output for sts_gui
handles.output = hObject;

%Default Values
handles.controller = struct;
handles.controller.model = '3braitenberg';
handles.antennae = struct;
    handles.antennae.static = 0;
handles.position = struct;
handles.noise = struct;
    handles.noise.bool = 0;

disp('<a href = "https://github.com/alpeq/SourceTaxisSimulator">Github repository: https://github.com/alpeq/SourceTaxisSimulator</a>')   
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sts_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = sts_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CONFIG
CONFIG.stop = 0;
CONFIG.pause = 0;

%handles.antennae.freq = str2double(get(handles.freqLeft, 'String'));  %
handles.antennae.freqLeft = str2double(get(handles.freqRight, 'String'));  %
handles.antennae.freqRight = str2double(get(handles.freqLeft, 'String'));  %

handles.antennae.mp = str2double(get(handles.mp, 'String'));
%handles.antennae.amp = str2double(get(handles.ampLeft, 'String'));
handles.antennae.ampRight = str2double(get(handles.ampLeft, 'String'));
handles.antennae.ampLeft = str2double(get(handles.ampRight, 'String'));
handles.antennae.kon = str2double(get(handles.kon, 'String'));
handles.antennae.koff = str2double(get(handles.koff, 'String'));
handles.antennae.ks = str2double(get(handles.ks, 'String'));

handles.controller.alpha = str2double(get(handles.alpha, 'String'));
handles.controller.g0 = str2double(get(handles.g0, 'String'));

handles.position.xpos= str2double(get(handles.xpos, 'String'));
handles.position.ypos= str2double(get(handles.ypos, 'String'));
handles.position.devpos= str2double(get(handles.devpos, 'String'));

handles.noise.powernoise= str2double(get(handles.noisepower, 'String'));


%create_interpFunc(handles.map.map_mean, handles.map.map_std, 5.5,-6.5,0,24);
create_interpFunc(handles.map.map_mean, handles.map.map_std, 6.5,-6.5,0,24);

handles.varName = 'STSGUI_';
[plotHandles] = simulation_GUI('STSGUI_', handles);
handles.simula_pHand  = [handles.simula_pHand plotHandles];

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in stopbutton.
function stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CONFIG
CONFIG.stop = 1;
guidata(hObject, handles);

% Can I Kill a function started??  Better stop it and continue but we can
% also kill it and come back here. Also what happen if you run Start 2
% times without stop 1st?


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Determine the selected data set.


str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val};
    case {'Plume'}
        map.string= 'Plume';
        str_map = load('odor_mapping2_long.mat');
        Source = [0 0 pi/2]; %-0.5
        x=linspace(5.5,-6.5); % Original 2,-3 0,12
        offset = 0;
        dynamic = 0;
    case {'Wide'}
        map.string= 'Wide';
        str_map = load('odor_mapping2_big_long.mat');
        Source = [0 0 pi/2]; %-0.5
        x=linspace(5.5,-6.5); % Original 2,-3 0,12
        offset = 0;
        dynamic = 0;
    case {'CFD Flow 1'}
        map.string= 'CFD1';
        str_map = load('odormap1_CFD_long.mat');
        Source = [0 0 pi/2]; %-0.5
        x=linspace(6,-6); % Original 2,-3 0,12
        offset = 0;
        dynamic = 0;
    case {'CFD Flow 2'}
        map.string= 'CFD2';
        str_map = load('odormap2_CFD_long.mat');
        Source = [0 0 pi/2]; %-0.5
        x=linspace(6,-6); % Original 2,-3 0,12
        offset = 0;
        dynamic = 0;
    case {'Incompressible '}
        map.string= 'standard300';
        str_map = load('standard300_iteration_10.mat');
        Source = [0 0 pi/2]; %-0.5        
        x=linspace(6,-6); % Original 2,-3 0,12
        offset = 10;
        dynamic = 1;
    case {'Compressible '}
        map.string= 'standard_111_v3';
        str_map = load('standard_111_v3_iteration_10.mat');
        Source = [0 0 pi/2]; %-0.5        
        x=linspace(6,-6); % Original 2,-3 0,12
        offset = 10;
        dynamic = 1;
    case {'Compressible Obs.'}
        map.string= 'hole_88_v3';
        str_map = load('hole_88_v3_iteration_10.mat');
        Source = [0 0 pi/2]; %-0.5        
        x=linspace(6,-6); % Original 2,-3 0,12
        offset = 10;
        dynamic = 1;   
    case {'Compressible Obs. Vis.'}
        map.string= 'hole_300_v3';
        str_map = load('hole_300_v3_iteration_40.mat');
        Source = [0 0 pi/2]; %-0.5        
        x=linspace(6,-6); % Original 2,-3 0,12
        offset = 40;
        dynamic = 1;
        % if dynamic just create the str_map.map_mean as zeros
    otherwise
        warning('Unexpected Map. Crash.')
end

map.map_mean = str_map.map_mean;
map.map_std = zeros(size(str_map.map_mean));%str_map.map_std;
map.source = [0 0 pi/2];
map.dynamic = dynamic;
map.offset = offset;
handles.map = map;
   

% Plot concentration
res = map.map_mean./max(max(map.map_mean));

y=linspace(0,24,200);
cla(handles.axesHandle);
axes(handles.axesHandle);
imagesc(handles.axesHandle, linspace(6.5,-6.5),y,zeros(100,100)); %flip
imh = imagesc(handles.axesHandle, x,y,(res)); %flip
colormap default;   % set colormap
tin=colorbar;
title(tin,'Normalize Odorant');
hold on

% Save the handles structure.
guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in cleanButton.
function cleanButton_Callback(hObject, eventdata, handles)
% hObject    handle to cleanButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete('MatrixD/*');
cleanPlot_GUI(handles.simula_pHand);


% --- Executes on selection change in controller.
function controller_Callback(hObject, eventdata, handles)
% hObject    handle to controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%{'braitenberg','Braitenberg'} {'dynamics','Dynamics'} {'3braitenberg','3Braitenberg'} {'3dynamics','3Dynamics'} {'3CRdynamics','3CRDynamics'}
            
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val};
    case {'Braitenberg 3'}
        model = '3braitenberg';
        immodel = imread('3braitenberg.png'); %flip
        imequ = imread('3braitenberg_equ.png'); %flip

    case {'Crossed Dynamic 3'}
        model = '3CRdynamics';
        immodel = imread('crossedDyn.png'); %flip 
        imequ = imread('crossedDyn_equ.png'); %flip 

    case {'Dynamic 3'}
        model = '3dynamics';
        immodel = imread('dynamic.png'); %flip 
        imequ = imread('dynamic_equ.png'); %flip 

        
    %otherwise
    %    warning('Unexpected Map. Crash.')
end


axes(handles.axesModel);
imshow(immodel);

axes(handles.axesEqu);
imshow(imequ);

handles.controller.model = model;
guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns controller contents as cell array
%        contents{get(hObject,'Value')} returns selected item from controller


% --- Executes during object creation, after setting all properties.
function controller_CreateFcn(hObject, eventdata, handles)
% hObject    handle to controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in antennae.
function antennae_Callback(hObject, eventdata, handles)
% hObject    handle to antennae (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
if val == 1.0
    handles.antennae.static = 0;
else
    handles.antennae.static = 1;
end
guidata(hObject,handles)


% Hint: get(hObject,'Value') returns toggle state of antennae



function freqLeft_Callback(hObject, eventdata, handles)
% hObject    handle to freqLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of freqLeft as text
%        str2double(get(hObject,'String')) returns contents of freqLeft as a double


% --- Executes during object creation, after setting all properties.
function freqLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freqLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mp_Callback(hObject, eventdata, handles)
% hObject    handle to mp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mp as text
%        str2double(get(hObject,'String')) returns contents of mp as a double


% --- Executes during object creation, after setting all properties.
function mp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ampLeft_Callback(hObject, eventdata, handles)
% hObject    handle to ampLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ampLeft as text
%        str2double(get(hObject,'String')) returns contents of ampLeft as a double


% --- Executes during object creation, after setting all properties.
function ampLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ampLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double


% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kon_Callback(hObject, eventdata, handles)
% hObject    handle to kon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kon as text
%        str2double(get(hObject,'String')) returns contents of kon as a double


% --- Executes during object creation, after setting all properties.
function kon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g0_Callback(hObject, eventdata, handles)
% hObject    handle to g0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g0 as text
%        str2double(get(hObject,'String')) returns contents of g0 as a double


% --- Executes during object creation, after setting all properties.
function g0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function koff_Callback(hObject, eventdata, handles)
% hObject    handle to koff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of koff as text
%        str2double(get(hObject,'String')) returns contents of koff as a double


% --- Executes during object creation, after setting all properties.
function koff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to koff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ks_Callback(hObject, eventdata, handles)
% hObject    handle to ks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ks as text
%        str2double(get(hObject,'String')) returns contents of ks as a double


% --- Executes during object creation, after setting all properties.
function ks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noisepower_Callback(hObject, eventdata, handles)
% hObject    handle to noisepower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noisepower as text
%        str2double(get(hObject,'String')) returns contents of noisepower as a double


% --- Executes during object creation, after setting all properties.
function noisepower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noisepower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xpos_Callback(hObject, eventdata, handles)
% hObject    handle to xpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xpos as text
%        str2double(get(hObject,'String')) returns contents of xpos as a double


% --- Executes during object creation, after setting all properties.
function xpos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ypos_Callback(hObject, eventdata, handles)
% hObject    handle to ypos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ypos as text
%        str2double(get(hObject,'String')) returns contents of ypos as a double


% --- Executes during object creation, after setting all properties.
function ypos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ypos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function devpos_Callback(hObject, eventdata, handles)
% hObject    handle to devpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of devpos as text
%        str2double(get(hObject,'String')) returns contents of devpos as a double


% --- Executes during object creation, after setting all properties.
function devpos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to devpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checknoise.
function checknoise_Callback(hObject, eventdata, handles)
% hObject    handle to checknoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checknoise
val = get(hObject,'Value');
if val == 1.0
    handles.noise.bool = 1;
else
    handles.noise.bool = 0;
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function simula_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate simula



function freqRight_Callback(hObject, eventdata, handles)
% hObject    handle to freqRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of freqRight as text
%        str2double(get(hObject,'String')) returns contents of freqRight as a double


% --- Executes during object creation, after setting all properties.
function freqRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freqRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ampRight_Callback(hObject, eventdata, handles)
% hObject    handle to ampRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ampRight as text
%        str2double(get(hObject,'String')) returns contents of ampRight as a double


% --- Executes during object creation, after setting all properties.
function ampRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ampRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pauseButton.
function pauseButton_Callback(hObject, eventdata, handles)
% hObject    handle to pauseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CONFIG;
if CONFIG.pause == 0
    CONFIG.pause = 1;
else
        CONFIG.pause = 0;
end

% Save the handles structure.
guidata(hObject,handles)


% --- Executes on button press in printTrajectory.
function printTrajectory_Callback(hObject, eventdata, handles)
% hObject    handle to printTrajectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Prints the last trajectory

drawLastFile_GUI(handles.varName);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over hyperref.
function hyperref_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to hyperref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%disp('<a href = "https://github.com/alpeq/SourceTaxisSimulator">Github repository: https://github.com/alpeq/SourceTaxisSimulator</a>')
%disp('Github repository: https://github.com/alpeq/SourceTaxisSimulator</a>')

% --- Executes during object creation, after setting all properties.
function hyperref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hyperref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%disp('<a href = "https://github.com/alpeq/SourceTaxisSimulator">Github repository: https://github.com/alpeq/SourceTaxisSimulator</a>')
%disp('Github repository: https://github.com/alpeq/SourceTaxisSimulator')
