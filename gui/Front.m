function varargout = Front(varargin)
% FRONT MATLAB code for Front.fig
%      FRONT, by itself, creates a new FRONT or raises the existing
%      singleton*.
%
%      H = FRONT returns the handle to a new FRONT or the handle to
%      the existing singleton*.
%
%      FRONT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRONT.M with the given input arguments.
%
%      FRONT('Property','Value',...) creates a new FRONT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Front_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Front_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Front

% Last Modified by GUIDE v2.5 04-May-2019 12:06:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Front_OpeningFcn, ...
    'gui_OutputFcn',  @Front_OutputFcn, ...
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


% --- Executes just before Front is made visible.
function Front_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Front (see VARARGIN)

% Choose default command line output for Front
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Front wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Front_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in WellList.
function WellList_Callback(hObject, eventdata, handles)
% hObject    handle to WellList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns WellList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from WellList
%create a list called contents containing all elements present in the
%listbox
contents = cellstr(get(hObject,'String'));
%Look at which chanels are selected for plottig and create a vector with
%them
ChanelsSelected=[get(handles.Channel1,'Value') get(handles.Channel2,'Value') get(handles.Channel3,'Value') get(handles.Channel4,'Value')];
ChanelsPossible=[1 2 3 4];
chans=ChanelsPossible(ChanelsSelected>0);
%Clear axis and plot the well selected
cla;
plot(handles.Project(1).returnWell(contents{get(hObject,'Value')}),chans);
handles.Project(1).returnWell(contents{get(hObject,'Value')}).Data(:,3);


% --- Executes on button press in Channel1.
function Channel1_Callback(hObject, eventdata, handles)
% hObject    handle to Channel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Channel1

% --- Executes on button press in Channel2.
function Channel2_Callback(hObject, eventdata, handles)
% hObject    handle to Channel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Channel2


% --- Executes on button press in Channel3.
function Channel3_Callback(hObject, eventdata, handles)
% hObject    handle to Channel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Channel3


% --- Executes on button press in Channel4.
function Channel4_Callback(hObject, eventdata, handles)
% hObject    handle to Channel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Channel4


% --- Executes on key press with focus on WellList and none of its controls.
function WellList_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to WellList (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in CreateProject.
function CreateProject_Callback(hObject, eventdata, handles)
% hObject    handle to CreateProject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in OpenFolder.
function OpenFolder_Callback(hObject, eventdata, handles)
%This button is responsible for opening a directory and creating a
%project from all the wells present in the directory.
% hObject    handle to OpenFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%FolderName=uigetdir('/Users/danielpacheco/REM Analytics Dropbox/EPFL_Lab/Wet_Lab/Megabace1000_data/MBF15machine/'); %Ask the user for the folder to open

FolderNames = uigetdir2('/Users/danielpacheco/REM Analytics Dropbox/EPFL_Lab/Wet_Lab/Megabace1000_data/',"Choose 2 runs (different T)");
if length(FolderNames)>2
    Expt = MException('Too many input files specified','Select 2 folders at most');
    throw(Expt);
end
text_folder = FolderNames+"/Text";
%call the function that reads a directory and outputs a list of wells
%The WellList is stored in handles.Project 
handles.Project=ReadStandardFolders(text_folder);

guidata(hObject,handles); %Save the handle

%plot(handles.Project.StandardData');

%We now update the listbox WellList to contain the name of all the wells
%that were used and set the Signal and Standard channels to the ones that
%are chosen.
set(handles.WellList,'String',handles.Project(1).WellNames);
set(handles.StandardChannel,'Value',handles.Project(1).Standard)
set(handles.SignalChannel,'Value',handles.Project(1).Signal)




% --- Executes on mouse press over axes background.
function axis1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
KeyPressed=get(gcbf,'CurrentKey');
C=get(hObject,'CurrentPoint');

switch KeyPressed
    case '1'
        set(handles.Peak1,'string',round(C(1,1)));
    case '2'
        set(handles.Peak2,'string',round(C(1,1)));
    case '3'
        set(handles.Peak3,'string',round(C(1,1)));
    case '4'
        set(handles.Peak4,'string',round(C(1,1)));
    case 'control'
        set(handles.CutOff,'string',round(C(1,1)));
        
end
C=get(hObject,'CurrentPoint');
C=C(1,1:2);
hold on
plot(C(1,1),C(1,2),'xk')


% --- Executes on selection change in StandardChannel.
function StandardChannel_Callback(hObject, eventdata, handles)
% hObject    handle to StandardChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StandardChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StandardChannel
handles.Project(1).Standard=get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on selection change in SignalChannel.
function SignalChannel_Callback(hObject, eventdata, handles)
% hObject    handle to SignalChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SignalChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SignalChannel
handles.Project(1).Signal=get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in PlotAllStandards.
function PlotAllStandards_Callback(hObject, eventdata, handles)
% hObject    handle to PlotAllStandards (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;
plot(handles.Project(1).StandardData');



function CutOff_Callback(hObject, eventdata, handles)
% hObject    handle to CutOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CutOff as text
%        str2double(get(hObject,'String')) returns contents of CutOff as a double

function CutOff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Baseline_Callback(hObject, eventdata, handles)
% hObject    handle to Baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Baseline as text
%        str2double(get(hObject,'String')) returns contents of Baseline as a double
function Baseline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function WaveletChoice_Callback(hObject, eventdata, handles)
% hObject    handle to WaveletChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WaveletChoice as text
%        str2double(get(hObject,'String')) returns contents of WaveletChoice as a double
function WaveletChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function WaveletThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to WaveletThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WaveletThreshold as text
%        str2double(get(hObject,'String')) returns contents of WaveletThreshold as a double


% --- Executes during object creation, after setting all properties.
function WaveletThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WaveletThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Peak1_Callback(hObject, eventdata, handles)
% hObject    handle to Peak1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Peak1 as text
%        str2double(get(hObject,'String')) returns contents of Peak1 as a double


% --- Executes during object creation, after setting all properties.
function Peak1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Peak1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Peak2_Callback(hObject, eventdata, handles)
% hObject    handle to Peak2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Peak2 as text
%        str2double(get(hObject,'String')) returns contents of Peak2 as a double


% --- Executes during object creation, after setting all properties.
function Peak2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Peak2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Peak3_Callback(hObject, eventdata, handles)
% hObject    handle to Peak3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Peak3 as text
%        str2double(get(hObject,'String')) returns contents of Peak3 as a double


% --- Executes during object creation, after setting all properties.
function Peak3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Peak3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Peak4_Callback(hObject, eventdata, handles)
% hObject    handle to Peak4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Peak4 as text
%        str2double(get(hObject,'String')) returns contents of Peak4 as a double


% --- Executes during object creation, after setting all properties.
function Peak4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Peak4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ScoringFunction.
function ScoringFunction_Callback(hObject, eventdata, handles)
% hObject    handle to ScoringFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ScoringFunction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ScoringFunction
CurentFolder=cd;
cd('functions/ScoringFunctions');
if ismac
FunctionList=regexp(ls(),'\w*(?=.m)','match');
else
    FunctionList=regexp(string(ls()),'\w*(?=.m)','match');
    FunctionList = FunctionList(3:end);
end
set(hObject,'String',FunctionList);
cd(CurentFolder)

% --- Executes during object creation, after setting all properties.
function ScoringFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScoringFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
CurentFolder=cd;
cd('functions/ScoringFunctions');
out_str = ls();
if not(ismac)
out_str = out_str(3:end,:);
FunctionList = split(string(out_str),'.m');
FunctionList = cellstr(FunctionList);
else
FunctionList=regexp(out_str,'\w*(?=.m)','match');
end

set(hObject,'String',FunctionList);
cd(CurentFolder)

% --- Executes on button press in ScoreProject.
function ScoreProject_Callback(hObject, eventdata, handles)
% hObject    handle to ScoreProject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%We score the corent project and open the Scoring interface.
%First step is to read all the parameters that have been set in the
%interface and that will be used for scoring.

%First the baseline
baseline=str2double(get(handles.Baseline,'string'));
%Cuttoff
cutoff=str2double(get(handles.CutOff,'string'));
%We now read the function speciffic parameters
%The text parameter
wavelet=get(handles.WaveletChoice,'string');
%The additional numerical parameter
waveletthreshold=str2double(get(handles.WaveletThreshold,'string'));
%We now read the distances (when they are needed
Distances=[str2double(get(handles.Peak1,'string')) str2double(get(handles.Peak2,'string'))...
    str2double(get(handles.Peak3,'string')) str2double(get(handles.Peak4,'string'))];
%We now identify which is the scoring fucntion that will be used
ScoreFunctions=cellstr(get(handles.ScoringFunction,'String'));
ScoreFunction=str2func(ScoreFunctions{get(handles.ScoringFunction,'Value')});
set(handles.ScoringFunction,'tag','scoringFunction') %where h is the handle of the slider
%We create an object of type Score, called Result, from the data taken from
%the project
Result=Score(handles.Project);
%And we score the Result calling the function DefaultScore that itself will
%call upon the specific scoring function
Result.DefaultScore(ScoreFunction,Distances,baseline,cutoff,wavelet,waveletthreshold);
%We now save Result to be taken up by the scoring interface
set(0,'userdata',Result)
%We open the scoring interface
SI=ScoringInterface;
%guidata(SI,handles)


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
modifiers = get(gcf,'currentModifier');
switch eventdata.Key
    case'rightarrow'
        MF=1/10; %By what fraction of the axis length should it be mooved or scaled
        Xlim=get(handles.axis1,'XLim');
        Xlength=Xlim(2)-Xlim(1);
        %If the shift buton is pressed, zoom in the axis, else move them to
        %the right
        if(ismember('shift',modifiers)) Xlim=[Xlim(1)+MF*Xlength Xlim(2)-MF*Xlength];
        else Xlim=[Xlim(1)+MF*Xlength Xlim(2)+MF*Xlength];
        end
        set(handles.axis1,'XLim',Xlim);
        
    case'leftarrow'
        MF=1/10; %By what fraction of the axis length should it be mooved or scaled
        Xlim=get(handles.axis1,'XLim');
        Xlength=Xlim(2)-Xlim(1);
        %If the shift button is pressed, zoom out of the axis, else move
        %them left
        if(ismember('shift',modifiers)) Xlim=[Xlim(1)-MF*Xlength Xlim(2)+MF*Xlength];
        else Xlim=[Xlim(1)-MF*Xlength Xlim(2)-MF*Xlength];
        end
        set(handles.axis1,'XLim',Xlim);
        
end


% --- Executes during object creation, after setting all properties.
function StandardChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StandardChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
