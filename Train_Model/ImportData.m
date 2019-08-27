function T_total = ImportData(filename)
start_path = 'C:\Users\danie\REM Analytics Dropbox\EPFL_Lab\Megabace1000_data\';
folders = uigetdir2(start_path);
total_size = 96*length(folders);
curdir = cd;
start = 1501;
last = 2801;
for i=1:length(folders)
    title = split(folders{i},'\');
    title = title(end);
    try
        files = dir([folders{i},'\text']);
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
        ID = parse_name(title);
        well_id =split(file.name,'.txt'); well_id = well_id(1);
        ID = strjoin([ID,well_id],'_');
        signal = content.data(:,[1,5]);
        if (j==1 && i==1)
            T_total = array2table(signal(start:min(size(signal,1),last),:),'VariableNames',{'time',char(ID)});
        else
            tab = array2table(signal(start:min(size(signal,1),last),:),'VariableNames',{'time',char(ID)});
            T_total = join(T_total,tab);
        end
    end
    %
    
end
%writetable(T_total,strjoin(string([filename,'.csv'])));
%%


end
