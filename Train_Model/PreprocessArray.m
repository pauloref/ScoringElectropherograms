function signal_array = PreprocessArray(signal_array)
%PREPROCESSARRAY Applied a Gaussian filter. Removes baseline and normalizes
% signal array.
% smooth with Gaussian filter
signal_array = smoothdata(signal_array,2,'gaussian',10);
% remove any trends by fitting line and removing line. Any value under the
% line is thresholded to 0.
signal_array = removeBaseline(signal_array);
% normalize by max value
max_values = repmat(max((signal_array)')',[1,size(signal_array,2)]);
signal_array = signal_array./max_values;


end

