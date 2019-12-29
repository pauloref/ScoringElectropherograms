function Plot2ndRun(handles)
%PLOTPEAKS is a function that plots all the peaks present in the current
%well. As such, it only takes as input the "handles" parameter. Which
%contains all the infrormation relative to the curent scoreing process.
%   Detailed explanation goes here

%If the standard peak marker is on, we plot standard peaks
if(get(handles.Signal2On,'Value')&& ~isempty(handles.Result.WellList2))
    Standard=handles.Result.WellList.Wells(handles.CurrentWell).Data(:,handles.Result.WellList.Signal);
    Standard2 = handles.Result.WellList2.Wells(handles.CurrentWell).Data(:,handles.Result.WellList2.Signal);                         
    x2 = [1:length(Standard2)] + handles.offset; % shift by offset set by sliding bar
    gca();
    hold on
    plot(x2,Standard2)
    

end

