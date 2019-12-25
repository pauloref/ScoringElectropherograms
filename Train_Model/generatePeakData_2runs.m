function [peak_data,labels] = generatePeakData_2runs(input_table,output_table,window_size,prominence,output_type)
%generatePeakData Gathers electropherogram data, extracts potential peaks
%and creates table with peak and corresponding label (1 if peak and 0 if
%false peak)
%output_type corresponds to format of final output. Can be a flat vector or
%a 2xwindow_size array
%   Detailed explanation goes here
if nargin<5
    prominence=0.025;
    output_type = 2;
end    
actual_window = window_size*2+1+2; %signal data and location relative to primer peak
if output_type == 1
    peak_data = zeros(2,actual_window-1,1,100000);
    %peak_data(100000,1) = image;
else
    peak_data = zeros(100000,5);
end
labels = zeros(100000,1);
signal_array = table2array(input_table(:,7:end));
%% Data Preprocessing
%% Preprocessing
% smooth with Gaussian filter
signal_array = smoothdata(signal_array,2,'gaussian',10);
% remove any trends by fitting line and removing line. Any value under the
% line is thresholded to 0.
signal_array = removeBaseline(signal_array);
% normalize by max value
max_values = repmat(max((signal_array)')',[1,size(signal_array,2)]);
signal_array = signal_array./max_values;
primer_positions = findPrimerPeak(signal_array,prominence);

%% Parsing table fields
primer_names = input_table.primer_ID;
well_names = input_table.well;
time_vals = split(string(input_table.Properties.VariableNames(7:end)),'t_');
time_vals = str2double(time_vals(:,:,2));
k=1; % index of peak data
for row_name=(output_table.Properties.RowNames')
    sample_idx = find(ismember(input_table.Properties.RowNames,row_name));
    label_idx = find(ismember(output_table.Properties.RowNames,row_name));
    primer = input_table.primer_ID(sample_idx);
    well = input_table.well(sample_idx);
    temperature = input_table.Th(sample_idx);
    pair_idxs = find(ismember(input_table.primer_ID,primer));
    pair_idx = pair_idxs(find(ismember(input_table.well(pair_idxs),well)));
    pair_idx = pair_idx(~ismember(pair_idx,sample_idx));
    pair_idx = pair_idx(1);
    signal_pair = signal_array([sample_idx,pair_idx],:);
    %% Now we will find the peaks of our sample
    [PKS,LOCS,W,P] = findpeaks(signal_pair(1,:),'MinPeakProminence',prominence);
    [PKS2,LOCS2,W2,P2] = findpeaks(signal_pair(2,:),'MinPeakProminence',prominence);
    % check if data is a blank
    if check_blank(LOCS,W) || check_blank(LOCS2,W2)
        warning(string(join(['blank at ',row_name])));
        continue;
    end
    % align peaks
    D = Align_peaks(signal_pair(1,:),signal_pair(2,:),prominence);
    % Label each peak
    %LOCS2 = LOCS2+D;
    if D==0
        idx1 = 1;
        idx2 = 1;
    elseif D<0
        idx1 = -D;
        idx2 = 1;
    else
        idx1 = 1;
        idx2 = D;
    end
%     close all
%     figure
%     plot (signal_pair(1,idx1:end))
%     hold on
%     plot (signal_pair(2,idx2:end))
%     hold off
%     legend('signal1','signal2')
    pkinfo2 = [PKS2',LOCS2',W2',P2']; % store peak data as matrix for the second signal
    for j = 1:length(LOCS)
       PK1 = PKS(j);
       LOC = LOCS(j);
       Ww = W(j);
       Pp = P(j);
       pkinfo1 = [PK1,LOC,Ww,Pp];
       if any(abs(1500+LOC-output_table{label_idx,:})<3) %check if peak is in label list
            labels(k) = 1; 
       else
           labels(k) = 0;
       end
       [PK2,LOC2,Ww2,Pp2]= match_peaks(pkinfo1,pkinfo2);
       try
           
           signal1 = signal_pair(1,LOC-window_size:LOC+window_size);
           signal2 = signal_pair(2,LOC-window_size+D:LOC+window_size+D);
%            figure
%            plot(signal1)
%            hold on
%            plot (signal2)
%            hold off
           max_loc = max(LOC,LOC2);
           if output_type ==1 
               %peak_data(k,1,:,1:actual_window-1) = image([[LOC-primer_positions(sample_idx);LOC2-primer_positions(pair_idx)],[signal1;signal2]]); %put signal pairs at same window
               peak_data(:,1:actual_window-1,1,k) = [[LOC/max_loc;LOC2/max_loc],[signal1;signal2]]; %put signal pairs at same window
           else
               peak_data(k,1:5) = [LOC-primer_positions(j),LOC-LOC2+D,PK1,Ww,Ww2]; %flatten signal
           end
           k = k+1;
       catch e
           fprintf('%s: %s',[e.identifier,e.message]);
           continue;
           
       end
    end
end

%aligned_signal.Properties.VariableNames(end) = {'primer_peak_location'};

labels(k:end) = [];
if output_type==1
    peak_data(:,:,:,k:end) = [];
    %peak_data(k:end) = [];
else
    peak_data(k:end,:)=[];
    peak_data=[peak_data,labels];
end


end

