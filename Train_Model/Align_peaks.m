%% script needs to load csv table produced by ImportData function
function time_values = Align_peaks(input_table,pfu)
if nargin<2
    pfu=false;
end
time_values = input_table;
names = time_values.Properties.RowNames;
time = Var2Num(time_values.Properties.VariableNames);
time =repmat(time,[height(input_table),1]);
primer_pk_locs = findPrimerPeak(table2array(input_table),200);
primer_pk_times = time(1,primer_pks_locs);
primer_pk_locs = repmat(time(:,primer_pk_locs),[width(input_table),1]);
time_values = array2table(time-time(:,primer_pk_locs));
time_values.Properties.RowNames= input_table.Properties.RowNames;
