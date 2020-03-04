function peak_data = generatePeakData_simple(input_table,output_table,window_size,prominence)
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
signal_array = table2array(input_table(:,7:end));

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
%% 
actual_window = window_size*2+1+2; %adding prominence, width at the end
peak_data = zeros(100000,actual_window);
labels = zeros(100000,1);
time_val = zeros(100000,1);
time_vector = Var2Num(input_table.Properties.VariableNames(7:end));
time_vector = linspace(time_vector(1),time_vector(end),width(input_table));
k=1;

for row_name=(input_table.Properties.RowNames')
    %if ~any(output_table.(i)~=0)
    %    continue;
    %else
    sample_idx = find(ismember(input_table.Properties.RowNames,row_name));
    label_idx = find(ismember(output_table.Properties.RowNames,row_name));
    
    [PKS,LOCS,W,P] = findpeaks(signal_array(sample_idx,:),'MinPeakProminence',prominence);
    %findpeaks(input_table.(i),'MinPeakProminence',prominence)
    if check_blank(LOCS,W)
        warning(string(join(['blank at ',row_name])));
        continue;
    end
    for j=1:length(LOCS)
        
        LOC = LOCS(j);
        Ww = W(j);
        Pp = P(j); 
        if any(abs(1500+LOC-output_table{label_idx,:})<3)
            labels(k) = 1;
        else 
            labels(k) = 0;
        end
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
labels(k:end) = [];
time_val(k:end) = [];
peak_data=[peak_data,time_val,labels];

end

