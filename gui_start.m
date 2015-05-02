function varargout = gui_start(varargin)
% GUI_START MATLAB code for gui_start.fig
%      GUI_START, by itself, creates a new GUI_START or raises the existing
%      singleton*.
%
%      H = GUI_START returns the handle to a new GUI_START or the handle to
%      the existing singleton*.
%
%      GUI_START('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_START.M with the given input arguments.
%
%      GUI_START('Property','Value',...) creates a new GUI_START or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_start_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_start_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_start

% Last Modified by GUIDE v2.5 05-Apr-2014 16:34:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_start_OpeningFcn, ...
    'gui_OutputFcn',  @gui_start_OutputFcn, ...
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

% File name for the input data set
%global input_data_set;
% Time domain for the input data set
% Valid values are day, month, quarter, year
%global time_domain;

% Time domain granularity (default value)
global granularity;
granularity=1;


% --- Executes just before gui_start is made visible.
function gui_start_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_start (see VARARGIN)

% Choose default command line output for gui_start
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_start wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% set(handles.radiobutton_day,'Enable','off');
% set(handles.radiobutton_month,'Enable','off');
% set(handles.radiobutton_quarter,'Enable','off');
% set(handles.radiobutton_year,'Enable','off');


% --- Outputs from this function are returned to the command line.
function varargout = gui_start_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton_year.
function radiobutton_year_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_year (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_year
global time_domain;
time_domain='year';
guidata(hObject,handles);


% --- Executes on button press in radiobutton_quarter.
function radiobutton_quarter_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_quarter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_quarter
global time_domain;
time_domain='quarter';
guidata(hObject,handles);

% --- Executes on button press in radiobutton_month.
function radiobutton_month_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_month (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_month
global time_domain;
time_domain='month';
guidata(hObject,handles);

% --- Executes on button press in radiobutton_day.
function radiobutton_day_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_day (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_day
global time_domain;
time_domain='day';
guidata(hObject,handles);

% --- Executes on button press in pushbutton_select_input.
function pushbutton_select_input_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_select_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open dialog box to select text fle
[input_file_name,input_path_name] = uigetfile({['*.txt']});

% Concatenate path and file
input_file  = fullfile(input_path_name, input_file_name);

% Put the full path to the file in the text box 
set(handles.edit_input_file,'String',input_file);

% Update handles structure
guidata(hObject,handles);
handles.input_file=input_file;
guidata(hObject,handles);


% --- Executes on button press in pushbutton_select_output.
function pushbutton_select_output_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_select_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open the Save as dialog box 
[output_file_name,output_path_name] = uiputfile('*.txt', 'Save output');
output_file = fullfile(output_path_name,output_file_name);

% Put the full path to the file in the text box 
set(handles.edit_output_file,'String',output_file);
handles.output_file=output_file;
guidata(hObject,handles);

% --- Executes on selection change in listbox_duration.
function listbox_duration_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_duration contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_duration


% --- Executes during object creation, after setting all properties.
function listbox_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_input_file_Callback(hObject, eventdata, handles)
% hObject    handle to edit_input_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_input_file as text
%        str2double(get(hObject,'String')) returns contents of edit_input_file as a double


% --- Executes during object creation, after setting all properties.
function edit_input_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_input_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_output_file_Callback(hObject, eventdata, handles)
% hObject    handle to edit_output_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_output_file as text
%        str2double(get(hObject,'String')) returns contents of edit_output_file as a double


% --- Executes during object creation, after setting all properties.
function edit_output_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_output_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_parse.
function pushbutton_parse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_parse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global time_domain;
global granularity; 
s = cputime;

inputTable = importdata(handles.input_file,'\t',1);
inputMatrix = inputTable.data;

% Lots to do here.  Much of the logic from date_ids.m would go in here.
% (Or would be put in functions and called from here.)
%
% In the end, we need to massage inputMatrix (i.e., the matrix read
% in by the input file) so that a date ID based on the selected time
% domain and granularity replaces the actual dates.
%
% For now, just make a copy of the inputMatrix 
inputMatrixWithDateID=inputMatrix;

% Write the matrix to the output file 
output_file=handles.output_file;
writetable(array2table(inputMatrixWithDateID), output_file, 'delimiter', '\t');


Parse_button_total_time = cputime - s

disp('Script complete')


% --- Executes when selected object is changed in uipanel9.
function uipanel9_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel9 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton_granularity_1.
function radiobutton_granularity_1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_granularity_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_granularity_1
global granularity;
granularity=1;


% --- Executes on button press in radiobutton_granularity_10.
function radiobutton_granularity_10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_granularity_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_granularity_10
global granularity;
granularity=.10;


% --- Executes on button press in radiobutton_granularity_100.
function radiobutton_granularity_100_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_granularity_100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_granularity_100
global granularity;
granularity=.01;
