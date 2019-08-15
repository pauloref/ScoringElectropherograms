function peak_data = generatePeakData(input_table,output_table,time_table,window_size,prominence)
%generatePeakData Gathers electropherogram data, extracts potential peaks
%and creates table with peak and corresponding label (1 if peak and 0 if
%false peak)
%   Detailed explanation goes here
if nargin<5
    prominence=1000;
end
    
actual_window = window_size*2+1;
peak_data = zeros(100000,actual_window);
labels = zeros(100000,1);
time_val = zeros(100000,1);
time_vector = input_table.(1);
k=1;
for i=2:length(input_table.Properties.VariableNames)
    %if ~any(output_table.(i)~=0)
    %    continue;
    %else
    [PKS,LOCS,W,P] = findpeaks(input_table.(i),'MinPeakProminence',prominence);
    %findpeaks(input_table.(i),'MinPeakProminence',prominence)
    
    for j=1:length(LOCS)
        LOC = LOCS(j);
        if any(abs(time_vector(LOC)-output_table.(i))<3)
            labels(k) = 1;
        else 
            labels(k) = 0;
        end
            try
               peak_data(k,1:actual_window) = input_table.(i)(LOC-window_size:LOC+window_size);
               time_val(k) = time_table.(i)(LOC);
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

