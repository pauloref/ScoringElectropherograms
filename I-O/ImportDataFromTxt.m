function signal_data = ImportDataFromTxt(filename,project_name,update)
%% Script that allows user to select files containing Text directory in them. The output is a table 
% with the time and signal of the wells in those files. 
%start_path = 'C:\Users\danie\REM Analytics Dropbox\EPFL_Lab\Megabace1000_data\';

folders = uigetdir2('/Users/danielpacheco/REM Analytics Dropbox/Laboratory/EPFL_Lab/Wet_Lab/Lab_Assays');
total_size = 96*length(folders);
curdir = cd;
start = 1500;
last = 2600;
arr = cell(total_size,1);
index = cell(total_size,1);
info = cell(total_size,7);
j = 0;
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
            fprintf('Could not locate file %s \n',folders{i});
            continue;
        end
    catch e
        fprintf("%s \n",e.message);
        continue;
    end
    
    
    %%
    n_files = length(files)-2;
    for file = files'
        
        if file.isdir
            continue;  
        end
        file_ending = char(file.name);
        file_ending = file_ending(end-3:end);
        if ~strcmp('.txt',file_ending)
            fprintf('Not a text file: %s \n',file.name);
            continue;
        end
        
        try
            content = importdata(file.name);
        catch e
            fprintf(e);
            continue;
        end
        j=j+1;
        well_id =split(file.name,'.txt'); well_id = well_id(1);
        [ID,info_table] = parse_name(title,well_id,project_name);
        info(j,:) = (info_table);
        index{j} = strjoin([ID,well_id],'_');
        
        signal = content.data(:,5);
        arr{j} = signal(start:min(size(signal,1),last),:)';
        
    end
    %
    
end
arr(j+1:end)=[];
info(j+1:end,:) = [];
index(j+1:end) = [];
names = {'date','project_id','plate_no','Th','Tl','well','primer'};
signal_data = cell2table(info);
signal_data.Properties.VariableNames = names;
signal_data.filename = index;
signal_data.Th = str2double(signal_data.Th);
signal_data.Tl = str2double(signal_data.Tl);
signal_data.plate_no = str2double(signal_data.plate_no);
signal_data.start = repmat((start),height(signal_data),1);
signal_data.project_id = repmat(project_name,height(signal_data),1);
signal_data.signal = (arr);
%file_out = jsonencode(signal_data);
%fid = fopen(filename,'wt');
%fprintf(fid, file_out);
%fclose(fid);
%%
% if nargin==3
%     PushTableToDB(signal_data);
% end
end
