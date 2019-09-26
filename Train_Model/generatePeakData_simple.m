function peak_data = generatePeakData_simple(input_table,output_table,window_size,prominence)
%generatePeakData Gathers electropherogram data, extracts potential peaks
%and creates table with peak and corresponding label (1 if peak and 0 if
%false peak)
%   Detailed explanation goes here
if nargin<4
    prominence=0.025;
end
signal_array = table2array(input_table(:,7:end));
signal_array = removeBaseline(signal_array,30);

max_values = repmat(max((signal_array)')',[1,size(signal_array,2)]);
signal_array = signal_array./max_values;    
primer_positions = findPrimerPeak(signal_array,prominence);
actual_window = window_size*2+1+3; %adding prominence, width and height at the end
peak_data = zeros(100000,actual_window);
labels = zeros(100000,1);
time_val = zeros(100000,1);
time_vector = Var2Num(input_table.Properties.VariableNames(7:end));
k=1;

for row_name=(output_table.Properties.RowNames')
    %if ~any(output_table.(i)~=0)
    %    continue;
    %else
    sample_idx = find(ismember(input_table.Properties.RowNames,row_name));
    label_idx = find(ismember(output_table.Properties.RowNames,row_name));
    
    [PKS,LOCS,W,P] = findpeaks(signal_array(sample_idx,:),'MinPeakProminence',prominence);
    %findpeaks(input_table.(i),'MinPeakProminence',prominence)
    if check_blank(LOCS)
        continue;
    end
    for j=1:length(LOCS)
        
        LOC = LOCS(j);
        PK = PKS(j);
        Ww = W(j);
        Pp = P(j); 
        if any(abs(time_vector(LOC)-output_table{label_idx,:})<3)
            labels(k) = 1;
        else 
            labels(k) = 0;
        end
            try
               peak_data(k,:) = [signal_array(sample_idx,LOC-window_size:LOC+window_size),PK,Ww,Pp];
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
peak_data=[peak_data,time_val,labels];

end

