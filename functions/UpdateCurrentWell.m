function  UpdateCurrentWell( handles )
%UpdateCurrentWell is a function designed to be used inside the
%ScoringInterface GUI. It takes as parameters the handles, and places the
%user defined information corresponding to the well, and saves in into the
%curent project
%   Detailed explanation goes here
handles.Result.ScoreStatus(handles.CurrentWell)=get(handles.ScoreStatus,'Value');
AssignSignalPeaksFromMatrix(handles.Result,handles.CurrentWell,get(handles.SignalPeaks,'Data'));
AssignSignalPeaksFromMatrix(handles.Result,handles.CurrentWell,get(handles.SignalPeaks,'Data'));
end

