%% script needs to load csv table produced by ImportData function
function D = Align_peaks(signal1,signal2,prominence)
% function finds shift of displacement of 1 signal with respect to the other 
% 


[PKS1,LOCS1,W1] = findpeaks(signal1,'MinPeakProminence',prominence); 
[PKS2,LOCS2,W2] = findpeaks(signal2,'MinPeakProminence',prominence);
close all
findpeaks(signal1,'MinPeakProminence',prominence)
hold on 
findpeaks(signal2,'MinPeakProminence',prominence)


[~,max_idx1] = max(PKS1);
[~,max_idx2] = max(PKS2);
max_pkloc1 = LOCS1(max_idx1);
max_pkloc2 = LOCS2(max_idx2);

subsignal1 = signal1(1:max_pkloc1-floor(W1(max_idx1)));
subsignal2 = signal2(1:max_pkloc2-floor(W2(max_idx2)));

if (check_blank(LOCS1,W1) || check_blank(LOCS2,W2))
        D= 0;
        return;
end
[~,~,D]=alignsignals(subsignal1,subsignal2,500);

if (D<0)
    %1st signal is early
    index1 = abs(D);
    index2 = 1;

else
    index1 = 1;
    index2 = D;
end
% plot(signal1(index1:end))
% hold on 
% plot(signal2(index2:end))
% legend('signal 1','signal 2')
% hold off
