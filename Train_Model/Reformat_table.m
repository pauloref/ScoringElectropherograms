%% script needs to load csv table produced by ImportData function
function aligned_table = Align_peaks(input_table)

aligned_table = input_table;
names = time_values.Properties.VariableNames;
time = time_values.time;
for i=2:length(names)
    [max_val,max_idx] = max(time_values.(i));
    aligned_t = time - time(max_idx);
    time_values.(i) = aligned_t;
end
