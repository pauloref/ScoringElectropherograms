%% script needs to load csv table produced by ImportData function
function D = Align_peaks(signal1,signal2,prominence)
% function finds shift of displacement of 1 signal with respect to the other 
% 
if nargin<3
    prominence=0.025;
end
if max(signal1)~=1
    signal1 = signal1/max(signal1);
end
if max(signal2)~=1
    signal2 = signal2/max(signal2);
end

[PKS1,LOCS1,W1,P1] = findpeaks(signal1,'MinPeakProminence',prominence); 
[PKS2,LOCS2,W2,P2] = findpeaks(signal2,'MinPeakProminence',prominence);
[~,max_loc1] = max(PKS1);
[~,max_loc2] = max(PKS2);
if max_loc1 ==1
    max_loc1 = 2;
end
if max_loc2 ==1
    max_loc2 = 2;
end
    
diff1 = PKS1(2:max_loc1) - PKS1(1:max_loc1-1);
diff2 = PKS2(2:max_loc2) - PKS2(1:max_loc2-1);


[~,piv1] = max(diff1); % take pivot point as peak with largest change relative to previous peaks
[~,piv2] = max(diff2);
piv1 = piv1 + 1; 
piv2 = piv2 + 1;

%[~,max_idx1] = max(PKS1);
%[~,max_idx2] = max(PKS2);
%subsignal1 = flattenPeaksToAlign(signal1,prominence);
%subsignal2 = flattenPeaksToAlign(signal2,prominence);
% close all
% findpeaks(signal1,'MinPeakProminence',prominence)
% hold on 
% findpeaks(signal2,'MinPeakProminence',prominence)
 
 
piv_pkloc1 = LOCS1(piv1);
piv_pkloc2 = LOCS2(piv2);


subsignal1 = signal1(1:piv_pkloc1-max(floor(W1(piv1)),30));
subsignal2 = signal2(1:piv_pkloc2-max(floor(W2(piv2)),30));

if (isempty(subsignal1) || isempty(subsignal2))
    D= 0;
    return;
end
[~,~,D]=alignsignals(subsignal1,subsignal2,500);

 
% if (D<0)
%   %1st signal is early
%   index1 = abs(D);
%   index2 = 1;
%  
% else
%   index1 = 1;
%   index2 = D;
% end
% plot(signal1(index1:end))
% hold on 
% plot(signal2(index2:end))
% legend(‘signal 1’,‘signal 2’)
% hold off
% if (D<0)
%     %1st signal is early
%     index1 = abs(D);
%     index2 = 1;
% 
% else
%     index1 = 1;
%     index2 = D;
% end
% plot(signal1(index1:end))
% hold on 
% plot(signal2(index2:end))
% legend('signal 1','signal 2')
% hold off
