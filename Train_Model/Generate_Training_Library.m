%% Generate training data for peaks
curdir = cd;
cd ..
cd('TargetScores/geltesting');
filedir = cd;
genpath(pwd);
target_file_dir = ls;
target_file_dir = string(target_file_dir);
cd(curdir);
target_files_idx = find(contains(target_file_dir,'.csv'));
if find(contains(target_file_dir,'target_data.csv'))
    return;
end

target_files = target_file_dir(target_files_idx);
j = 1;
for file = target_files'
    
    cd(filedir);
    file = split(file,' ');
    file = file(1);
    data = readtable(file);
    name = split(file,'.csv');
    name = name(1);
    name = parse_name(name);
    name = repmat(name,[height(data),1]);
    name = join([name,string(data.(1))],'_');
    data.(1) = name;
    data.Properties.VariableNames{1} = 'Wells';
    if j ==1
       T_total = data; 
    else
       try
       T_total = [T_total;data];
       catch 
           a= 1;
       end
    end
    j = j+1;
    
    
    
end
 T_total = sortrows(T_total,'Wells','ascend');
     T_total = transposeTable(T_total);
    writetable(T_total,'target_data.csv');
