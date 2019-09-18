function location = findPrimerPeak(input_electropherogram,prominence_val)
%FINDPRIMERPEAK Finds primer peak given the time series of an
%electropherogram
%   input_electropherogram = vector containing signal data
%   prominence_val = minimum prominence of primer peak
if nargin<2
    prominence_val = 0.05;
end
N = size(input_electropherogram,1);
location = zeros(N,1);
for i = 1:N
[PKS,locs,W,P]=findpeaks(input_electropherogram(i,:),'MinPeakProminence',prominence_val);
%findpeaks(input_electropherogram(i,:),'MinPeakProminence',prominence_val)
    locs = locs(W>3);
    %locs = locs(PKS(W>3)<0.8); %primer peak has less than half of max
    if isempty(locs)
        location(i) = 1;
    else
        location(i) = locs(1);   
    end
end
end
