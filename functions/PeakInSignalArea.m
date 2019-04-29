function [Y,X,A] = PeakInSignal( Signal )
%takes as input a signal piece from an electropherogram, and returns the
%height and position of the biggest peak present in the signal.
%   Detailed explanation goes here
X=0;
Y=0;
[pY, pX, width, pro]=findpeaks(Signal);
if(isempty(pY)&&isempty(pX))
    [Y X]=max(Signal);
    return;
end
[Y,imax]=max(pY);
A=pro(imax)*width(imax);
X=pX(imax)+round(width(imax)/2);

end

