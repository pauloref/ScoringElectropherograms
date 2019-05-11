function UpdateScoringInterface(handles)
%UpdateScoringInterface is a function designed to be called inside the
%description of the GUI ScoringInterface
%The function updates the values of the interface. It is to be called if
%something relating to data is modified. This way the values can be
%updated.
%   Detailed explanation goes here

%We plot the selected well
%We now set the value of the tickbox to match the status of the well
handles.CurrentWell=(get(handles.WellListBox,'Value'));
set(handles.ScoreStatus,'Value',handles.Result.ScoreStatus(handles.CurrentWell));
set(handles.StandardPeaks,'Data',StandardPeakMatrix(handles.Result,handles.CurrentWell));
set(handles.SignalPeaks,'Data',SignalPeakMatrix(handles.Result,handles.CurrentWell));
set(handles.MutantFraction,'Data', handles.Result.MutantFraction{handles.CurrentWell});
set(handles.PeakNumber,'String',int2str(size(get(handles.SignalPeaks,'Data'),1)));
PlotSelectedWell(handles);
end


