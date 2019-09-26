%% Generate training data for peaks
function T_total = CompileLabelFiles(output_table_name)
file_paths = uigetdir2('/Users/danielpacheco/Documents/GitHub/ScoringElectropherograms/TrainingLib');
%total_size = 96*length(folders);
j = 1;
for file = string(file_paths)
    data = readtable(string(file),'ReadVariableNames',true,'ReadRowNames',true);
    if ismac
        name = split(file,'/');
    else
        name = split(file,'\');
    end
    if size(char(data.Properties.RowNames),2) < 4
        
        name = name(end);
        name = parse_name(name);
        name = repmat(name,[height(data),1]);
        name = join([name,string(data.Properties.RowNames)],'_');
        data.Properties.RowNames = cellstr(name);
    end
    if j ==1
       T_total = data; 
    else
       try
       T_total = vertcat(T_total,data);
       catch 
           a= 1;
       end
    end
    j = j+1;
    
    
    
end
 T_total = sortrows(T_total,'RowNames','ascend');
 writetable(T_total,join([output_table_name,'.csv']),'WriteRowNames',true);
