%% script needs to load csv table produced by ImportData function
function aligned_signal = Align_peaks_2runs(input_table)
% outputs a modified table where 2 electropherograms are aligned with respect
% to primer peak and with respect to run at different temperature
close all
%% Parameters
peak_prominence = 0.05;
window = 700;
%% Data Parsing
signal_array = table2array(input_table);
signal_array = removeBaseline(signal_array,30);
max_values = repmat(max((signal_array)')',[1,width(input_table)]);
signal_array = signal_array./max_values;
primer_names = char(input_table.Properties.RowNames);
well_names = char(strtrim(string(primer_names)));
well_names = string(well_names(:,end-7:end));
well_names = split(well_names,'_');
well_names = well_names(:,end);
primer_names = split(string(primer_names(:,1:20)),'_');
primer_names = join([primer_names(:,2),primer_names(:,3)],'-'); 
aligned_pairs = zeros(2,701);
time_vals = split(string(input_table.Properties.VariableNames),'t_');
time_vals = str2double(time_vals(:,:,2));
k=0;
for primer=unique(primer_names,'stable')'
    primer_idx = find(ismember(strtrim(primer_names),primer));
    for well= unique(strtrim(well_names),'stable')'
        k=k+1;
        pair_idx = primer_idx(find(ismember(strtrim(well_names(primer_idx)),well))); %get index of wells
        output_ID = input_table.Properties.RowNames(pair_idx(2)); %% input table for 2nd run (higher T)
        signal_pairs = signal_array(pair_idx,:);
        offset_locs = findPrimerPeak(signal_pairs,peak_prominence); %use primer peak as offset
        try
        aligned_pairs(1,:) = signal_pairs(1,offset_locs(1):offset_locs(1)+700);
        aligned_pairs(2,:) = signal_pairs(2,offset_locs(2):offset_locs(2)+700);
        catch
            continue
        end
        output_signal = aligned_pairs(2,:)-aligned_pairs(1,:);
        output_signal(output_signal<0) = 0;
        if k==1
            aligned_signal=array2table([output_signal,time_vals(offset_locs(2))],'RowNames',output_ID);
        else
            T=array2table([output_signal,time_vals(offset_locs(2))],'RowNames',output_ID);
            aligned_signal = vertcat(aligned_signal,T);
        end
%         figure 
%         subplot(2,1,1)
%         plot (aligned_pairs(1,:),'color','blue')
%         hold on 
%         plot (aligned_pairs(2,:),'color','red')
%         legend({'run1','run2'})
%         subplot(2,1,2)
%         plot(output_signal,'color','red')
%         legend({'output'})
%         title(join([primer,well],'_'),'Interpreter','None')
%         hold off
        
    end
    
    
end
aligned_signal.Properties.VariableNames(end) = {'primer_peak_location'};


