function signal_array_normalized = PreprocessArray(signal_array)
%PREPROCESSARRAY Applied a Gaussian filter. Removes baseline and normalizes
% signal array.

% smooth with Gaussian filter
signal_array_smoothed = smoothdata(signal_array,2,'gaussian',8);
% remove any trends by fitting line and removing line. Any value under the
% line is thresholded to 0.
signal_array_baseline = removeBaseline(signal_array_smoothed);
% normalize by max value
max_values = repmat(max((signal_array_baseline)')',[1,size(signal_array_baseline,2)]);
signal_array_normalized = signal_array_baseline./max_values;

%Plot
% subplot(3,1,1);
% findpeaks(signal_array(3,1:800),'MinPeakProminence',50);
% legend('Raw Signal')
% subplot(3,1,2);
% findpeaks(signal_array_smoothed(3,1:800),'MinPeakProminence',50);
% legend('Smoothed Signal')
% subplot(3,1,3);
% findpeaks(signal_array_baseline(3,1:800),'MinPeakProminence',50);
% legend('Baseline-removed Signal')

end

