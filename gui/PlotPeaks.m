function PlotPeaks(handles)
%PLOTPEAKS is a function that plots all the peaks present in the current
%well. As such, it only takes as input the "handles" parameter. Which
%contains all the infrormation relative to the curent scoreing process.
%   Detailed explanation goes here

%If the standard peak marker is on, we plot standard peaks
if(get(handles.StandardPeaksOn,'Value') && handles.Result.ScoreStatus(handles.CurrentWell))
    StandardPeaks=handles.Result.StandardPeaks{handles.CurrentWell};
    Standard=handles.Result.WellList.Wells(handles.CurrentWell).Data(:,handles.Result.WellList.Standard);
    for i=1:length(StandardPeaks)
        k=StandardPeaks{i};
        if(k.X ==0 || k.Y==0)
            continue
        end
        %We now plot the area between the standard, and the baseline of the
        %peak.
        jbfill((k.Start:k.End),Standard(k.Start:k.End)',repmat(k.Baseline,k.End-k.Start+1,1)');        
        plot(k.X,k.Y,'xr');
    end
    
end

%If the signal peak marker is on, we plot the signal peaks
if(get(handles.SignalPeaksOn,'Value') && handles.Result.ScoreStatus(handles.CurrentWell))
    SignalPeaks=handles.Result.SignalPeaks{handles.CurrentWell};
    Signal=handles.Result.WellList.Wells(handles.CurrentWell).Data(:,handles.Result.WellList.Signal);
    for i=1:length(SignalPeaks) %We loop through each peak
        k=SignalPeaks{i}; %Assign the peak to a variable k that we will use
        if(k.X ==0 || k.Y==0)
            continue
        end
        %We now plot the area between the signal, and the baseline of the
        %peak.
        jbfill((k.Start:k.End),Signal(k.Start:k.End)',repmat(k.Baseline,k.End-k.Start+1,1)');
        plot(k.X,k.Y,'xk');
    end
    
end

end


