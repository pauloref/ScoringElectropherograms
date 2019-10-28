function varargout = ScoringInterface(varargin)
% SCORINGINTERFACE MATLAB code for ScoringInterface.fig
%      SCORINGINTERFACE, by itself, creates a new SCORINGINTERFACE or raises the existing
%      singleton*.
%
%      H = SCORINGINTERFACE returns the handle to a new SCORINGINTERFACE or the handle to
%      the existing singleton*.
%
%      SCORINGINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCORINGINTERFACE.M with the given input arguments.
%
%      SCORINGINTERFACE('Property','Value',...) creates a new SCORINGINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ScoringInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ScoringInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ScoringInterface

% Last Modified by GUIDE v2.5 21-Oct-2019 17:28:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ScoringInterface_OpeningFcn, ...
    'gui_OutputFcn',  @ScoringInterface_OutputFcn, ...
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


% --- Executes just before ScoringInterface is made visible.
function ScoringInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ScoringInterface (see VARARGIN)

% Choose default command line output for ScoringInterface
handles.output = hObject;
if (isempty(varargin))
    handles.Result=get(0,'userdata');
end
        

handles.CurrentWell=1;
% Update handles structure
guidata(hObject, handles);
set(handles.WellListBox,'String',handles.Result.WellList.WellNames);
set(handles.file_name_edit, 'String', handles.Result.fileName);
% UIWAIT makes ScoringInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ScoringInterface_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in WellListBox.
function WellListBox_Callback(hObject, eventdata, handles)
% hObject    handle to WellListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns WellListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from WellListBox

%We inentify the well that is selected, and return it's number. This value
%is then stored as a property of the handles in such a way that it can be
%called uppon by other buttons in the interface.
contents = cellstr(get(hObject,'String'));
handles.CurrentWell=handles.Result.WellList.wellNumber(contents{get(hObject,'Value')});
guidata(hObject,handles);
%The interface is now updated.
UpdateScoringInterface(handles);
%We now proceed to plotting it using a dedicated function for the purpose
%of this interface.


% --- Executes during object creation, after setting all properties.
function WellListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WellListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StandardSignalOn.
function StandardSignalOn_Callback(hObject, eventdata, handles)
% hObject    handle to StandardSignalOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StandardSignalOn
UpdateScoringInterface(handles);


% --- Executes on button press in StandardPeaksOn.
function StandardPeaksOn_Callback(hObject, eventdata, handles)
% hObject    handle to StandardPeaksOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StandardPeaksOn
UpdateScoringInterface(handles);


% --- Executes on button press in SignalOn.
function SignalOn_Callback(hObject, eventdata, handles)
% hObject    handle to SignalOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SignalOn
UpdateScoringInterface(handles);


% --- Executes on button press in SignalPeaksOn.
function SignalPeaksOn_Callback(hObject, eventdata, handles)
% hObject    handle to SignalPeaksOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SignalPeaksOn
UpdateScoringInterface(handles);


% --- Executes on button press in ScoreStatus.
function ScoreStatus_Callback(hObject, eventdata, handles)
% hObject    handle to ScoreStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of ScoreStatus
handles.Result.ScoreStatus(handles.CurrentWell)=get(hObject,'Value');
UpdateScoringInterface(handles);


% --- Executes during object creation, after setting all properties.
function StandardPeaks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StandardPeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'ColumnName',{'Y','X'});

% --- Executes during object creation, after setting all properties.
function SignalPeaks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SignalPeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'ColumnName',{'Y','X'});



function WindowSize_Callback(hObject, eventdata, handles)
% hObject    handle to WindowSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WindowSize as text
%        str2double(get(hObject,'String')) returns contents of WindowSize as a double


% --- Executes during object creation, after setting all properties.
function WindowSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WindowSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SavePeaks.
function SavePeaks_Callback(hObject, eventdata, handles)
% hObject    handle to SavePeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%This button will save peak information in a spreadsheat. The information
%stored will be: X, Y and Area. Each will be in a different sheet of the
%file.
Wells=cellstr(get(handles.WellListBox,'String'));
%[Filename,Folder,Type]=uiputfile('*.xlsx','Save Mutant Fractions');
[Filename,Folder,Type]=uiputfile('*.xlsx','Save Peaks',string(handles.Result.fileName));
locdir=cd;
cd(Folder);
Variables={'X','Y','Area'};

for i=1:3
    values=GetPeakValue(handles.Result,Variables{i});
    T=table(Wells,values);
    writetable(T,Filename,'WriteRowNames', false,'Sheet',i);
end
cd(locdir);
UpdateCurrentWell(handles);
UpdateScoringInterface(handles);

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
modifiers = get(gcf,'currentModifier');
%eventdata.Key
switch eventdata.Key
    case 'space' %Change score status, from scored to unscored, or inverse
        %UpdateScoringInterface(handles);
        Status=get(handles.ScoreStatus,'Value');
        %handles.Result.ScoreStatus(handles.CurrentWell)= ~Status
        set(handles.ScoreStatus,'Value',~Status);
        UpdateCurrentWell(handles);
        UpdateScoringInterface(handles);
        
    case 's' %Switch Signal peak and Signal plot on and off
        set(handles.SignalOn,'Value',~get(handles.SignalOn,'Value'));
        set(handles.SignalPeaksOn,'Value',~get(handles.SignalPeaksOn,'Value'));
        UpdateCurrentWell(handles);
        UpdateScoringInterface(handles);
        
    case'd' %Wticeh signal plot on and off
        set(handles.SignalPeaksOn,'Value',~get(handles.SignalPeaksOn,'Value'));
        UpdateCurrentWell(handles);
        UpdateScoringInterface(handles);
        
    case'q'%If the standard peaks are scored and the signal ones are not
        %Use the information of the standard peaks to score the signal ones
        Window=str2double(get(handles.WindowSize,'string'));
        StandardPeaks=get(handles.StandardPeaks,'Data');
        SignalPeaks=get(handles.SignalPeaks,'Data');
        Signal=handles.Result.WellList.SignalData(handles.CurrentWell,:);
        for i=1:4
            pos=StandardPeaks(i,2);
            SignalPeaks(i,:)=PeakInSignal(Signal( (pos-Window):(pos+Window)));
            SignalPeaks(i,2)=+pos;
            set(handles.SignalPeaks,'Data',SignalPeaks);
            UpdateCurrentWell(handles);
            UpdateScoringInterface(handles);
        end
        
    case'rightarrow'
        MF=1/10; %By what fraction of the axis length should it be mooved or scaled
        Xlim=get(handles.axes1,'XLim');
        Xlength=Xlim(2)-Xlim(1);
        %If the shift buton is pressed, zoom in the axis, else move them to
        %the right
        if(ismember('shift',modifiers)) Xlim=[Xlim(1)+MF*Xlength Xlim(2)-MF*Xlength];
        else Xlim=[Xlim(1)+MF*Xlength Xlim(2)+MF*Xlength];
        end
        set(handles.axes1,'XLim',Xlim);
        
    case'leftarrow'
        MF=1/10; %By what fraction of the axis length should it be mooved or scaled
        Xlim=get(handles.axes1,'XLim');
        Xlength=Xlim(2)-Xlim(1);
        %If the shift button is pressed, zoom out of the axis, else move
        %them left
        if(ismember('shift',modifiers)) Xlim=[Xlim(1)-MF*Xlength Xlim(2)+MF*Xlength];
        else Xlim=[Xlim(1)-MF*Xlength Xlim(2)-MF*Xlength];
        end
        set(handles.axes1,'XLim',Xlim);
        
    case 'c'
        if(ismember('control',modifiers))
            set(handles.StandardPeaks,'Data',[0,0]);
            set(handles.SignalPeaks,'Data',[0,0]);
            UpdateCurrentWell(handles);
            UpdateScoringInterface(handles);
        end
        
    case 'downarrow'
        if(get(handles.WellListBox,'Value') < handles.Result.WellList.N)
            set(handles.WellListBox,'Value',get(handles.WellListBox,'Value')+1);
            handles.CurrentWell=(get(handles.WellListBox,'Value'));
            guidata(hObject,handles);
            UpdateScoringInterface(handles);
        end
        
    case 'uparrow'
        if(get(handles.WellListBox,'Value') > 1)
            set(handles.WellListBox,'Value',get(handles.WellListBox,'Value')-1);
            handles.CurrentWell=(get(handles.WellListBox,'Value'));
            guidata(hObject,handles);
            UpdateScoringInterface(handles);
        end
    %case 'p'
    %    axes1_PeakAssign(hObject, eventdata, handles)
        
        
end
%guidata(hObject,handles);



% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Window=str2double(get(handles.WindowSize,'string'));
KeyPressed=get(gcbf,'CurrentKey');
C=get(hObject,'CurrentPoint');
pos=round(C(1,1));
Signal=handles.Result.WellList.SignalData(handles.CurrentWell,:);
Standard=handles.Result.WellList.StandardData(handles.CurrentWell,:);
StandardPeaks=get(handles.StandardPeaks,'Data');
SignalPeaks=get(handles.SignalPeaks,'Data');

switch KeyPressed
    case 0
    case {'1', '2', '3', '4','5','6','7','8','9'}
        n=str2double(KeyPressed);
        [a b]=PeakInSignal(Signal( (pos-Window):(pos+Window)));
        SignalPeaks(n,:)=[a b+pos-Window-1];
        [a b]=PeakInSignal(Standard((pos-Window):(pos+Window)));
        StandardPeaks(n,:)=[a b+pos-Window-1];
    case 'control'
        
end
set(handles.StandardPeaks,'Data',StandardPeaks);
set(handles.SignalPeaks,'Data',SignalPeaks);
UpdateCurrentWell(handles);
UpdateScoringInterface(handles);



function MutantFraction_Callback(hObject, eventdata, handles)
% hObject    handle to MutantFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MutantFraction as text
%        str2double(get(hObject,'String')) returns contents of MutantFraction as a double


% --- Executes during object creation, after setting all properties.
function MutantFraction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MutantFraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveResults.
function SaveResults_Callback(hObject, eventdata, handles)
% hObject    handle to SaveResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Wells=cellstr(get(handles.WellListBox,'String'));
Fractions=cell2mat(handles.Result.MutantFraction)';
T=table(Wells,Fractions);
[Filename,Folder,Type]=uiputfile('*.csv','Save Mutant Fractions');
locdir=cd;
cd(Folder);
writetable(T,Filename,'WriteRowNames', false);
cd(locdir);


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% switch eventdata.Key
%     case 'space'
%         Status=get(handles.ScoreStatus,'Value');
%         set(handles.ScoreStatus,'Value',~Status);
%         UpdateCurrentWell(handles);
%         UpdateScoringInterface(handles);
% end


% --- Executes on key press with focus on WellListBox and none of its controls.
function WellListBox_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to WellListBox (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% switch eventdata.Key
%     case 'space'
%         Status=get(handles.ScoreStatus,'Value');
%         set(handles.ScoreStatus,'Value',~Status);
%         UpdateCurrentWell(handles);
%         UpdateScoringInterface(handles);
% end


% --- Executes on button press in CompareScore.
function CompareScore_Callback(hObject, eventdata, handles)
% hObject    handle to CompareScore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileName=uigetfile('*.csv','Select benchmark Data');
Benchmark=readtable(FileName);
CurentFractions=handles.Result.MutantFraction';
Error=CurentFractions- Benchmark.Fractions;
CorrectNoScore=(isnan(Benchmark.Fractions) & isnan(CurentFractions));
FalseNoScore=(isnan(CurentFractions) & (Benchmark.Fractions >= 0));
FalseScore=(isnan(Benchmark.Fractions) & (CurentFractions >= 0));
AverageSqError=mean(Error.^2,'omitnan')
sum(CorrectNoScore)
sum(FalseNoScore)
sum(FalseScore)


% --- Executes on slider movement.
function XPosition_Callback(hObject, eventdata, handles)
% hObject    handle to XPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function XPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Zoom_Callback(hObject, eventdata, handles)
% hObject    handle to Zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Zoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function PeakNumber_Callback(hObject, eventdata, handles)
% hObject    handle to PeakNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PeakNumber as text
%        str2double(get(hObject,'String')) returns contents of PeakNumber as a double


% --- Executes during object creation, after setting all properties.
function PeakNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PeakNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClearPeaks.
function ClearPeaks_Callback(hObject, eventdata, handles)
%This is a button that clear all peaks present in the current well.
% hObject    handle to ClearPeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.StandardPeaks,'Data',[0,0]);
set(handles.SignalPeaks,'Data',[0,0]);
UpdateCurrentWell(handles);
UpdateScoringInterface(handles);



% --- Executes on button press in savetotraininglibrary.
function savetotraininglibrary_Callback(hObject, eventdata, handles)
% hObject    handle to savetotraininglibrary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Wells=cellstr(get(handles.WellListBox,'String'));
%[Filename,Folder,Type]=uiputfile('*.xlsx','Save Mutant Fractions');

Variable='X';
values=GetPeakValue(handles.Result,Variable);
val_names = repmat('values',[9,1]);
val_names = join([char(val_names),string(('1':'9')')],'_');
%row_names = repmat(join(['t_',handles.Result.fileName]),[length(Wells),1]);
row_names = repmat(handles.Result.fileName,[length(Wells),1]);
row_names = join([row_names,string(Wells)],'_');
%col_names = cellstr('Wells',col_names);
T=array2table(values,'RowNames',row_names,'VariableNames',val_names);
locdir = cd;
try
[Filename,Folder,Type]=uigetfile('*.csv','Save Peaks');
data = readtable([Folder,Filename],'ReadRowNames',true,'ReadVariableNames',true);
data = [data;T];
catch
[Filename,Folder,Type]=uiputfile(join([string(handles.Result.fileName),".csv"]),'Save Peaks');
data = T;
end


%data = transposeTable(data);
data = sortrows(data,'RowNames','ascend');
cd(Folder);
writetable(data,Filename,'WriteRowNames',true);
% fprintf('Target data successfully saved. Now saving signal data. \n');
% start = 1501; %% 15 min 
% finish = 2698; %% ≈27 min
% signal = handles.Result.WellList.SignalData(:,start:finish);
% time = handles.Result.WellList.Wells(1).Read(start:finish);
% col_names = repmat('t',[length(time),1]);
% col_names = join([string(col_names),num2str(time)],'_')';
% T = array2table(signal,'RowNames',row_names,'VariableNames',col_names);
% 
% try
% [Filename,Folder,Type]=uigetfile('*.csv','Append Input Data to File');
% data = readtable(Filename,'ReadVariableNames',true,'ReadRowNames',true); %% rows should be samples and columns 
% data.Properties.RowNames = data.(1);
% data.(1) =[];
% data = [data;T];
% catch
% [Filename,Folder,Type]=uiputfile('input_data.csv','Create Input Data File',handles.Result.fileName);
% data = T;
% end
% data = sortrows(data,'RowNames','ascend');
% writetable(data,Filename,'WriteRowNames',true,'WriteVariableNames',true);
fprintf('Input data successfully saved. \n');
cd(locdir);
UpdateCurrentWell(handles);
UpdateScoringInterface(handles);


function file_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to file_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_name_edit as text
%        str2double(get(hObject,'String')) returns contents of file_name_edit as a double


% --- Executes during object creation, after setting all properties.
function file_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
number_idx=[1:12:96,...
            2:12:96,...
            3:12:96,...
            4:12:96,...
            5:12:96,...
            6:12:96,...
            7:12:96,...
            8:12:96,...
            9:12:96,...
            10:12:96,...
            11:12:96,...
            12:12:96];
letter_idx=[1:8:96,...
            2:8:96,...
            3:8:96,...
            4:8:96,...
            5:8:96,...
            6:8:96,...
            7:8:96,...
            8:8:96];
if strcmp(handles.Result.WellList.WellList{2},'A02')   %swap indeces
    handles.Result.WellList.WellList = handles.Result.WellList.WellList(number_idx);
    handles.Result.WellList.Wells = handles.Result.WellList.Wells(number_idx);
    handles.Result.togglePeakScores(number_idx);
else
    handles.Result.WellList.WellList = handles.Result.WellList.WellList(letter_idx);
    handles.Result.WellList.Wells = handles.Result.WellList.Wells(letter_idx);
    handles.Result.togglePeakScores(letter_idx);
end
UpdateScoringInterface(handles);
ScoringInterface_OpeningFcn(hObject, eventdata, handles,{2});




    