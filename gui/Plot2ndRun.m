function Plot2ndRun(handles)
%PLOTPEAKS is a function that plots all the peaks present in the current
%well. As such, it only takes as input the "handles" parameter. Which
%contains all the infrormation relative to the curent scoreing process.
%   Detailed explanation goes here

%If the standard peak marker is on, we plot standard peaks
if(get(handles.Signal2On,'Value')&& ~isempty(handles.Result.WellList2))
    Signal2 = handles.Result.WellList2.Wells(handles.CurrentWell).Data(:,handles.Result.WellList2.Signal);                         
    Signal2(end) = NaN;
    t2 = handles.Result.WellList2.Wells(handles.CurrentWell).Read - handles.offset;
    % shift by offset set by sliding bar
    gca();
    hold on
    alpha_values = ones(length(t2),1)*0.3;
    patch(t2,Signal2,'blue','EdgeColor','blue',...
    'FaceVertexAlphaData',alpha_values,'AlphaDataMapping','none',...
    'EdgeAlpha','interp')
    %s = plot(t2,Signal2,'b');
    %alpha(s,.5);
    
    

end

