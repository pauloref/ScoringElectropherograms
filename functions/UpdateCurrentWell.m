function  UpdateCurrentWell( handles )
%UpdateCurrentWell is a function designed to be used inside the
%ScoringInterface GUI. It takes as parameters the handles, and places the
%user defined information corresponding to the well, and saves in into the
%curent project
%   Detailed explanation goes here

handles.Result.ScoreStatus(handles.CurrentWell)=get(handles.ScoreStatus,'Value');
handles.Result.StandardPeaks{handles.CurrentWell}=get(handles.StandardPeaks,'Data');
handles.Result.SignalPeaks{handles.CurrentWell}=get(handles.SignalPeaks,'Data');

end

