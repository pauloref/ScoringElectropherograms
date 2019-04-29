function [ Peak ] = GetPeak( peak_position, signal )
%GetPeak returns a signal containing the peak arround the position it takes
%as input
%   GetPeak is a function which is part of the toolbox to automaticaly
%   analyse electropherograms. It takes as input the estimated position of
%   a peak, and returns a signal containng the whole peak around the area
%   given as input. 


%The general hypothesis is that a peak position is that the peak is within
%a +/- 50 scan range from the position given. 
window=80;
peak_width=30;
subsignal=signal( (peak_position-window):(peak_position+window));
derivate=diff(subsignal);
[M,I]=max(subsignal);


end

