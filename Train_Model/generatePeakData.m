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
actual_window = window_size*2+1+2; %adding prominence, width at the end
peak_data = zeros(100000,actual_window);
time_val = zeros(100000,1);
time_vector = 1:size(signal_array,2);
time_vector = 1499 + time_vector;
k=1;

for row_name=(input_table.filename_input)'
    sample_idx = find(ismember(input_table.filename_input,row_name));
    
    [PKS,LOCS,W,P] = findpeaks(signal_array(sample_idx,:),'MinPeakProminence',prominence);
   
    if check_blank(LOCS,W)
        warning(string(join(['blank at ',row_name])));
        continue;
    end
    for j=1:length(LOCS)
        
        LOC = LOCS(j);
        Ww = W(j);
        Pp = P(j);
        try
            peak_data(k,:) = [signal_array(sample_idx,LOC-window_size:LOC+window_size),Ww,Pp];
            time_val(k) = 1500+LOC - primer_positions(sample_idx);
            k=k+1;
        catch
            
            warning('window is out of bounds');
            continue;
        end
        
        %end
    end
    
end
peak_data(k:end,:)=[];
time_val(k:end) = [];
peak_data=[time_val,peak_data];

end

