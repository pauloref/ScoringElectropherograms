function T_total = ImportData(filename,project_name)
%% Script that allows user to select files containing Text directory in them. The output is a table 
% with the time and signal of the wells in those files. 
%start_path = 'C:\Users\danie\REM Analytics Dropbox\EPFL_Lab\Megabace1000_data\';
folders = uigetdir2('/Users/danielpacheco/REM Analytics Dropbox/EPFL_Lab/Wet_Lab/Megabace1000_data/MBF15machine/54_primer_assay/');
total_size = 96*length(folders);
curdir = cd;
start = 1200;
last = 2698;
for i=1:length(folders)
    if ismac
        title = split(folders{i},'/');
    else
        title = split(folders{i},'\');
    end
    title = title(end);
    try
        if ismac
            files = dir([folders{i},'/text']);
        else
            files = dir([folders{i},'\text']);
        end
        addpath(genpath(folders{i}));
        if isempty(files)
            printf('Could not locate file');
            continue;
        end
    catch exception
        return;
    end
    j = 0;
    
    %%
    n_files = length(files)-2;
    for file = files'
        
        if file.isdir
            continue;
            
        end
        j=j+1;
        content = importdata(file.name);
        well_id =split(file.name,'.txt'); well_id = well_id(1);
        [ID,info_table] = parse_name(title,well_id,project_name);
        ID = strjoin([ID,well_id],'_');
        info_table.Properties.RowNames = ID;
        if length(content.data(:,1))< last
            patch = zeros(last-size(content.data,1),size(content.data,2));
            content.data = [content.data;patch];
            content.data(:,1) = 0:last-1;
        end
        time = repmat('t',[length(content.data(:,1)),1]);
        time = (join([string(time(start:last)),(num2str(content.data(start:last,1)))],'_'));
        
        signal = content.data(:,5);
        if (j==1 && i==1)
            T_total = array2table(signal(start:min(size(signal,1),last),:)','RowNames',string(ID),'VariableNames',time);
            T_total = [info_table,T_total];
        else
            tab = array2table(signal(start:min(size(signal,1),last),:)','RowNames',string(ID),'VariableNames',time);
            tab = [info_table,tab];
            T_total = vertcat(T_total,tab);
        end
    end
    %
    
end
T_total.Th = str2double(T_total.Th);
T_total.Tl = str2double(T_total.Tl);
T_total = sortrows(T_total,'RowNames','ascend');
writetable(T_total,strjoin(string([filename,'.csv'])),'WriteRowNames',true,'WriteVariableNames',true);
%%


end

