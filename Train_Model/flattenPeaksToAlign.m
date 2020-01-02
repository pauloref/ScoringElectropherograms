function subsignal = flattenPeaksToAlign(signal,prominence)
%FLATTENPEAKSTOALIGN Will locate peaks of given prominence and replace them
%with interpolated signal between shoulders of peaks
%   signal: Normalized signal with respect to max value
%   prominence: Mean peak prominence to apply the filter. 0.05 typical.

[PKS,LOCS,Ws,P] = findpeaks(signal,'MinPeakProminence',prominence); 
if (check_blank(LOCS,Ws))
    subsignal=[];
    return;
end
subsignal = signal; % initalize subsignal
for i=1:length(LOCS)
    LOC = LOCS(i);
    W = Ws(i);
    xq = LOC-ceil(W):LOC+ceil(W); % get query points 
    x = [xq(1),xq(end)]; %end points
    v = signal(x);%values
    subsignal(xq) = interp1(x,v,xq); 
    %subsignal(xq) = ones('like',signal(xq))*mean(signal);
end
%figure
%plot(signal-subsignal)
%hold on 
%plot(subsignal)
end

