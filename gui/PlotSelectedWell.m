function PlotSelectedWell(handles)
%This function is for use exclusively within the Gui ScoringInterface. It
%can be called upon in any of the callback functions to plot the curently
%selected well in the interface.

ChanelsSelected=[get(handles.StandardSignalOn,'Value') get(handles.SignalOn,'Value') ];
ChanelsPossible=[handles.Result.WellList.Standard handles.Result.WellList.Signal ];
chans=ChanelsPossible(ChanelsSelected>0);
%Clear axis and plot the well selected

cla;
plot(handles.Result.WellList.Wells(handles.CurrentWell),chans);
hold on
if(get(handles.StandardPeaksOn,'Value') && handles.Result.ScoreStatus(handles.CurrentWell))
    SP=handles.Result.StandardPeaks{handles.CurrentWell};
    plot(SP(:,2),SP(:,1),'xr');
end
if(get(handles.SignalPeaksOn,'Value') && handles.Result.ScoreStatus(handles.CurrentWell))
    SP=handles.Result.SignalPeaks{handles.CurrentWell};
    plot(SP(:,2),SP(:,1),'xk');
end
hold off
end

