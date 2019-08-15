function [final_locs,IDS] = ScoreFile(model,target_data)
raw_data_table = ImportData();
time_vals = Align_peaks(raw_data_table);
prominence = 400;
window = 30;
final_locs = cell(width(time_vals)-1,1);
IDS = final_locs;
k = 1;
time = raw_data_table.(1);
for i = 2:width(time_vals)-1
    signal = (raw_data_table.(i));
    aligned_times = time_vals.(i);
    [PKS,LOCS,W,P] = findpeaks(signal,'MinPeakProminence',prominence);
    input = zeros(length(PKS),window*2+2);
    for j=1:length(PKS)
        try
        input(j,1:end-1) = signal(LOCS(j)-window:LOCS(j)+window);
        catch 
            warning('window out of bounds');
            continue;
        end
        input(j,end) = aligned_times(LOCS(j));
    end
    labels = model.predictFcn(input);
    final_locs{k} = time(LOCS(labels==1));
    if isempty(final_locs{k})
        final_locs{k} = 0;
    end
    IDS{k} = raw_data_table.Properties.VariableNames(i);   
    %findpeaks(input_table.(i),'MinPeakProminence',prominence)
    
    plot(time,signal)
    title(IDS{k},'Interpreter', 'none')
    text_labels = cellstr(num2str((1:length(final_locs{k}))'));
    
    try
        labelpoints(final_locs{k},signal(LOCS(labels==1)),text_labels);
        
    catch
        
    end
    try
        target_idx = find(ismember(target_data.Properties.VariableNames,IDS{k}));
        labelled_peaks=target_data.(target_idx);
        text_labels = cellstr(repmat('v',[sum(sign(labelled_peaks)),1]));
        peak_idx = find(ismember(raw_data_table.time,labelled_peaks));
        labelled_peak_val = signal(peak_idx);
        labelpoints(labelled_peaks(labelled_peaks~=0),labelled_peak_val,text_labels,'N',0.1);
        k = k+1;
    catch
        k = k+1;
        warning('No label for this sample');
    end
    
end