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

% Last Modified by GUIDE v2.5 20-Dec-2020 20:48:00

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

set(handles.WellListBox,'String',handles.Result.WellList.WellNames);
set(handles.file_name_edit, 'String', handles.Result.fileName);
if (handles.Result.PlateCount>1)
    handles.OFFSET_CST = Align_peaks(handles.Result.WellList.SignalData(handles.CurrentWell,:)...
                                       ,handles.Result.WellList2.SignalData(handles.CurrentWell,:));
    handles.offset = handles.OFFSET_CST;
end
handles.WellSignalRepository = MongoBaseRepository('10.244.2.46','Organism',27017,'WellSignal','root','root');
handles.WellPeakRepository = MongoBaseRepository('10.244.2.46','Organism',27017,'WellPeak','root','root');
guidata(hObject, handles);
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

if ~isempty(handles.Result.WellList2)
    handles.OFFSET_CST = Align_peaks(handles.Result.WellList.SignalData(handles.CurrentWell,:)...
                                       ,handles.Result.WellList2.SignalData(handles.CurrentWell,:));
    handles.offset = handles.OFFSET_CST;
end
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
        MF=1/20; %By what fraction of the axis length should it be mooved or scaled
        Xlim=get(handles.axes1,'XLim');
        Xlength=Xlim(2)-Xlim(1);
        %If the shift buton is pressed, zoom in the axis, else move them to
        %the right
        if(ismember('shift',modifiers)) 
            Xlim=[Xlim(1)+MF*Xlength Xlim(2)-MF*Xlength];
        else
            Xlim=[Xlim(1)+MF*Xlength Xlim(2)+MF*Xlength];
        end
        set(handles.axes1,'XLim',Xlim);
        
    case'leftarrow'
        MF=1/20; %By what fraction of the axis length should it be mooved or scaled
        Xlim=get(handles.axes1,'XLim');
        Xlength=Xlim(2)-Xlim(1);
        %If the shift button is pressed, zoom out of the axis, else move
        %them left
        if(ismember('shift',modifiers)) 
            Xlim=[Xlim(1)-MF*Xlength Xlim(2)+MF*Xlength];
        else
            Xlim=[Xlim(1)-MF*Xlength Xlim(2)-MF*Xlength]; 
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
%offset = get(hObject,'Value');
offset = get(hObject,'Value')*1000-500;
handles.offset = handles.OFFSET_CST + offset;
guidata(hObject,handles);
UpdateScoringInterface(handles);


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



% --- Executes on button press in 
function savePeaks_Callback(hObject, eventdata, handles)
% hObject    handle to savesignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%[Filename,Folder,Type]=uiputfile('*.xlsx','Save Mutant Fractions');
wells = handles.Result.WellList.Wells;
    
for well=wells
   wellPeak = well.toWellPeaks();
   handles.WellPeakRepository.insert(wellPeak);
end
fprintf('Input data successfully saved. \n');


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
    handles.Result.WellList = handles.Result.WellList.SwapWellOrder();
    if (handles.Result.PlateCount>1)
       handles.Result.WellList2 = handles.Result.WellList2.SwapWellOrder(); 
    end
    handles.Result.togglePeakScores(number_idx);
UpdateScoringInterface(handles);
ScoringInterface_OpeningFcn(hObject, eventdata, handles,{2});


    

% --- Executes on button press in signal2on.
function Signal2On_Callback(hObject, eventdata, handles)
% hObject    handle to Signal2On (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateScoringInterface(handles);
% Hint: get(hObject,'Value') returns toggle state of Signal2On


% --- Executes on button press in swapPlatesButton.
function swapPlatesButton_Callback(hObject, eventdata, handles)
% hObject    handle to swapPlatesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ask user if wants to override peak information
answer = questdlg('If you change plates the peak data will be overriden. Want to continue?', ...
	'Swap Plates', ...
	'Yes','Cancel','Cancel');

switch answer
    case 'Yes'
        handles.Result = handles.Result.toggleCurrentRun();
        %% Fetch current score function and parameters for scoring
        
        %First the baseline
        baseline=str2double(get(findall(0,'tag','Baseline'),'string'));
        %Cuttoff
        cutoff=str2double(get(findall(0,'tag','CutOff'),'string'));
        %We now read the function speciffic parameters
        %The text parameter
        wavelet=get(findall(0,'tag','WaveletChoice'),'string');
        
        %The additional numerical parameter
        
        waveletthreshold=str2double(get(findall(0,'tag','WaveletThreshold'),'string'));
        %We now read the distances (when they are needed
        Distances=[str2double(get(findall(0,'tag','Peak1'),'string')) str2double(get(findall(0,'tag','Peak2'),'string'))...
            str2double(get(findall(0,'tag','Peak3'),'string')) str2double(get(findall(0,'tag','Peak4'),'string'))];
        %Fetch Score function
        ScoreFunctionHandle = findall(0,'tag','scoringFunction');
        ScoreFunctions=cellstr(get(ScoreFunctionHandle,'String'));
        ScoreFunction=str2func(ScoreFunctions{get(ScoreFunctionHandle,'Value')});
        %% Score peaks
        handles.Result.DefaultScore(ScoreFunction,Distances,baseline,cutoff,wavelet,waveletthreshold);
        guidata(hObject,handles);
        %% Call opening function
        ScoringInterface_OpeningFcn(hObject, eventdata, handles,1); % put non-empty varargin to use current handles
    case 'Cancel'
        
        
end





% --- Executes on button press in open_peak_file.
function open_peak_file_Callback(hObject, eventdata, handles)
% hObject    handle to open_peak_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,directoryName] = uigetfile({'.csv';'.xlsx'},'Select peak file');
path = join([directoryName,filename],"");
peakTable = importPeakFile(path);
fileWells = split(peakTable.Properties.RowNames,"_");
fileWells = fileWells(:,end);
obj = handles.Result;
list = string(split(strjoin(obj.WellList.WellList),' '));
fileIdx = 1;
Standard=obj.WellList.StandardData; %get standard signal
Signal=obj.WellList.SignalData; %get signal
Window=3;
for fileWell = fileWells'
    %corresponding index in current welllist
    i=obj.WellList.wellNumber(fileWell);
    peaks = peakTable{fileIdx,:};
    PeakPos = cell(1,length(peaks));
    for n=1:length(peaks(peaks~=0))
        
        pos = (peaks(n));
        [a b]=PeakInSignal(Signal(i, (pos-Window):(pos+Window)));
        SignalPeaks(n,:)=[a b+pos-Window-1];
        [a b]=PeakInSignal(Standard(i,(pos-Window):(pos+Window)));
        StandardPeaks(n,:)=[a b+pos-Window-1];
        PeakPos(n)={Peak(peaks(n),Signal(i,:))};
    end
    handles.Result.SignalPeaks{i}=PeakPos;
    handles.Result.StandardPeaks{i}=PeakPos;
    handles.Result.ScoreStatus(i)=1;
    fileIdx = fileIdx + 1;
end
UpdateScoringInterface(handles);





% --- Executes on button press in savesignal.
function saveSignal_Callback(hObject, eventdata, handles)
% hObject    handle to savesignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% saves raw signal to db
wells = handles.Result.WellList.Wells;
for well=wells
   signal = well.toWellSignal();
   handles.WellSignalRepository.insert(signal);
end
fprintf('Signal data successfully saved. \n');

% --- Executes on button press in SaveMutantFractions.
function SaveMutantFractions_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMutantFractions (see GCBO)
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



function primer_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to primer_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of primer_name_edit as text
%        str2double(get(hObject,'String')) returns contents of primer_name_edit as a double
primerName = get(hObject,'String');
for i=1:length(handles.Result.WellList.Wells)
   if isempty(handles.Result.WellList.Wells(i).PrimerName)
       handles.Result.WellList.Wells(i).PrimerName = primerName;
   end
end
handles.Result.WellList.Wells(handles.CurrentWell).PrimerName = primerName;
UpdateScoringInterface(handles);

% --- Executes during object creation, after setting all properties.
function primer_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to primer_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tl_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Tl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tl_edit as text
%        str2double(get(hObject,'String')) returns contents of Tl_edit as a double
tl = str2double(get(hObject,'String'));
handles.Result.WellList.Tl = tl;

% --- Executes during object creation, after setting all properties.
function Tl_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Th_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Th_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Th_edit as text
%        str2double(get(hObject,'String')) returns contents of Th_edit as a double
th = str2double(get(hObject,'String'));
handles.Result.WellList.Th = th;

% --- Executes during object creation, after setting all properties.
function Th_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Th_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
