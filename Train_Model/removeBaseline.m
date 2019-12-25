function detrended_data = removeBaseline(input_electropherogram,window)
%removeBaseline Finds baseline last section of the electropherogram
%and removes it from signal 
if nargin<2
   window = 100;
end
%baseline=mean(input_electropherogram(:,end-window:end),2);
detrended_data=zeros(size(input_electropherogram));
for i=1:size(input_electropherogram,1)
   moving_min = movmin(input_electropherogram(i,:),window);
   detrended_data(i,:) = input_electropherogram(i,:)-moving_min;
end
%findpeaks(input_electropherogram(i,:),'MinPeakProminence',prominence_val)

% detrended_data=zeros(size(input_electropherogram));
% for i=1:size(input_electropherogram,1)
%     detrended_data(i,:) = detrend(input_electropherogram(i,:));
% end
% detrended_data(detrended_data<0) = 0;
