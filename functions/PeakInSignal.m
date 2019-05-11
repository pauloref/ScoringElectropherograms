function [Y, X] = PeakInSignal( Signal )
%takes as input a signal piece from an electropherogram, and returns the
%height and position of the biggest peak present in the signal.
%   Detailed explanation goes here
X=0;
Y=0;
[pY, pX, width, pro]=findpeaks(Signal);
if(isempty(pY))
    [Y X]=max(Signal);
    return;
end
[~,imax]=max(pro);
%A=pro(imax)*width(imax);
Y=pY(imax);
X=pX(imax);

end

