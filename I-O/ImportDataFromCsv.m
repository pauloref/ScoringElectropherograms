function labels = ImportDataFromCsv()
%IMPORTDATAFROMCSV Summary of this function goes here
%   Detailed explanation goes here
[filenames, pathname] = uigetfile({'*.csv'},'MultiSelect','on');
filepaths = strjoin([pathname,filenames],"");
cd(pathname);
labels = readtable(string(filenames(1)),'ReadRowNames',true);
for file=filenames(2:end)
    labels2 = readtable(string(file),'ReadRowNames',true);
    labels = [labels;labels2];
end
end

