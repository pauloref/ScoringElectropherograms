function peak_data = generatePeakData(input_table,prominence,window_size)
%generatePeakData Gathers electropherogram data, extracts potential peaks
%and creates table with peak and corresponding label (1 if peak and 0 if
%false peak)
%   Detailed explanation goes here
%% Argument parsing
if nargin<3
    window_size = 10;
end
if nargin<2
    prominence=0.025;
end

%% Pre-processing
signal_array = table2array(input_table(:,10:end));

%% Preprocessing
% smooth with Gaussian filter
signal_array = PreprocessArray(signal_array);
primer_positions = findPrimerPeak(signal_array,prominence);
%%
actual_window = window_size*2+4; %shape features + 4 features: prominence, # peaks identified, current peak position.
peak_data = zeros(100000,actual_window);
time_val = zeros(100000,1);
time_vector = 1:size(signal_array,2);
time_vector = 1499 + time_vector;
%project_id = cell(100000,1);
k=1;

for row_name=(input_table.filename_input)'
    sample_idx = find(ismember(input_table.filename_input,row_name));
    
    [PKS,LOCS,W,P] = findpeaks(signal_array(sample_idx,:),'MinPeakProminence',prominence);
   
    if check_blank(LOCS,W)
        warning(string(join(['blank at ',row_name])));
        continue;
    end
    peak_count = length(PKS);
    %p_id = input_table.project_id(sample_idx);
    for j=1:length(LOCS)
        
        LOC = LOCS(j);
        Ww = W(j);
        Pp = P(j);
        Pk = PKS(j);
        try
            %project_id(k) = p_id;
            shape_features =  signal_array(sample_idx,LOC-window_size:LOC+window_size);
            shape_features = shape_features/max(shape_features);
            
            peak_data(k,:) = [Pp,peak_count,j,shape_features];
            time_val(k) = LOC - primer_positions(sample_idx);
            k=k+1;
        catch
            
            warning('window is out of bounds');
            continue;
        end
        
        %end
    end
    
end
%project_id(k:end)=[];
peak_data(k:end,:)=[];
time_val(k:end) = [];
peak_data=[time_val,peak_data];

%res = array2table(project_id,'VariableNames',{'project_id'});
res2 = array2table(peak_data);
res2.Properties.VariableNames(1:4) = {'relative_time','prominence','peak_count','peak_pos'};
res2.Properties.VariableNames(5:end) = matlab.internal.datatypes.numberedNames('normalized_signal',1:41);
peak_data = res2;

end

