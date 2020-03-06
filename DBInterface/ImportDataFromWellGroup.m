function [outputArg1,outputArg2] = ImportDataFromWellGroup(signalarr,scoretable,row_names)
%IMPORTDATAFROMWELLGROUP Generates a table combining electropherogram data
% and scores
%   signalarr: mxn matrix where m is the number of electropherograms and n
%   is the time they were ran for
%   scoretable: Table with scores
%   row_names: Name that will be parsed cell with date, project_id, plate_no,Th,Tl,well,primer

names = {'date','project_id','plate_no','Th','Tl','well','primer'};
signal_data = cell2table(info_table);
signal_data.Properties.VariableNames = names;
names = {'date','project_id','plate_no','Th','Tl','well'};
signal_data = cell2table(info_table);
signal_data.Properties.VariableNames = names;
end

