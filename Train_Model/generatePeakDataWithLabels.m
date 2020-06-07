function peak_data = generatePeakDataWithLabels(input_table,output_table,window_size,prominence)
%generatePeakData Gathers electropherogram data, extracts potential peaks
%and creates table with peak and corresponding label (1 if peak and 0 if
%false peak)
%   Detailed explanation goes here
%% Argument parsing
if nargin<2
    output_table = [];
end
if nargin<3 
    window_size = 30;
end
if nargin<4
    prominence=0.025;
end

%% Pre-processing
signal_array = table2array(input_table(:,10:end));

%% Preprocessing
% smooth with Gaussian filter
signal_array = PreprocessArray(signal_array);
primer_positions = findPrimerPeak(signal_array,prominence);
%% 
actual_window = window_size*2+1+2+1; %adding prominence, width at the end
peak_data = zeros(100000,actual_window);
labels = zeros(100000,1);
time_val = zeros(100000,1);
%project_id = cell(100000,1);
%file_name = cell(100000,1);
time_vector = 1:size(signal_array,2);
time_vector = 1499 + time_vector;
k=1;

for row_name=(output_table.Properties.RowNames')
    %if ~any(output_table.(i)~=0)
    %    continue;
    %else
    sample_idx = find(ismember(input_table.filename_input,row_name));
    label_idx = find(ismember(output_table.Properties.RowNames,row_name));
    
    [PKS,LOCS,W,P] = findpeaks(signal_array(sample_idx,:),'MinPeakProminence',prominence);
    %findpeaks(input_table.(i),'MinPeakProminence',prominence)
    if check_blank(LOCS,W)
        warning(string(join(['blank at ',row_name])));
        continue;
    end
    peak_count = length(PKS);
    %p_id = input_table.project_id(sample_idx);
    %f_name = input_table.filename_input(sample_idx);
    for j=1:length(LOCS)
        PK = PKS(j);
        LOC = LOCS(j);
        Ww = W(j);
        Pp = P(j); 
        if any(abs(1500+LOC-output_table{label_idx,:})<3)
            labels(k) = 1;
        else 
            labels(k) = 0;
        end
            try
               shape_features =  signal_array(sample_idx,LOC-window_size:LOC+window_size);
               shape_features = shape_features/max(shape_features); % collect only shape
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
peak_data(k:end,:)=[];
labels(k:end) = [];
time_val(k:end) = [];
%file_name(k:end) = [];
peak_data=[time_val,peak_data,labels];
%res = array2table([project_id,file_name],'VariableNames',{'project_id','file_name'});
res2 = array2table(peak_data);
res2.Properties.VariableNames(1:4) = {'relative_time','prominence','peak_count','peak_pos'};
res2.Properties.VariableNames(5:end-1) = matlab.internal.datatypes.numberedNames('normalized_signal',1:41);
res2.Properties.VariableNames(end) = {'labels'};
peak_data = res2;
end

