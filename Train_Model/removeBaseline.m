function filtered_signal = removeBaseline(input_electropherogram,window)
%removeBaseline Finds baseline last section of the electropherogram
%and removes it from signal 
if nargin<2
    window = 50;
end
baseline=mean(input_electropherogram(:,end-window:end),2);
%findpeaks(input_electropherogram(i,:),'MinPeakProminence',prominence_val)
filtered_signal= input_electropherogram - baseline;
filtered_signal(filtered_signal<0) = 0;
end
