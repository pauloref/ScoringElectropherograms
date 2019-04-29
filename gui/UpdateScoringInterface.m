function UpdateScoringInterface(handles)
%UpdateScoringInterface is a function designed to be called inside the
%description of the GUI ScoringInterface
%The function updates the values of the interface. It is to be called if
%something relating to data is modified. This way the values can be
%updated.
%   Detailed explanation goes here

%We plot the selected well
%We now set the value of the tickbox to match the status of the well
set(handles.ScoreStatus,'Value',handles.Result.ScoreStatus(handles.CurrentWell))
set(handles.StandardPeaks,'Data',handles.Result.StandardPeaks{handles.CurrentWell})
set(handles.SignalPeaks,'Data',handles.Result.SignalPeaks{handles.CurrentWell})
set(handles.MutantFraction,'String', round(handles.Result.MutantFraction(handles.CurrentWell)*100))
PlotSelectedWell(handles);
end


