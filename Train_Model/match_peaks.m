function [PK2,LOC2,Ww2,Pp2] = match_peaks(single_peak,peak_vector)
%match_peaks: This function will compare the peak of one signal with the peaks of a corresponding signal at 
%a different temperature
%   single_peak= vector composed of peak height, location, witdh and
%   prominence obtained from findpeaks function
%   peak_vector: matrix where each row corresponds to a peak on the 2nd
%   signal. Contains same number of columns as single_peak
% Function will choose the peak that gives the lowest cross entropy. 

%loss = -1/length(single_peak)*single_peak*log(peak_vector');
joint_vectors = [single_peak;peak_vector];
max_values = max(joint_vectors);
max_values = repmat(max_values,size(peak_vector,1),1);
normalized_peak_vector= peak_vector./max_values;
normalized_single_pk = repmat(single_peak,size(peak_vector,1),1)./max_values;

loss = mean((normalized_single_pk-normalized_peak_vector).^2,2);
[~,min_idx] = min(loss);

PK2 = peak_vector(min_idx,1); LOC2 = peak_vector(min_idx,2);
Ww2 = peak_vector(min_idx,3); Pp2 = peak_vector(min_idx,4);

end

