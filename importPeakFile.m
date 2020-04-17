function outputTable = importPeakFile(path)
%% Function allows one to import a table from peak values 
outputTable = table();
if (endsWith(path,".csv"))
    outputTable = readtable(path,"ReadVariableNames",true,"ReadRowNames",true);

end
