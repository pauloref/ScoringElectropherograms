function [name,info_table] = parse_name (input_name,well,project_name)
    
    name = split(input_name,'.csv');
    if length(name)<2
        name = split(input_name,'.xls');
        if length(name)<2
            name = split(input_name,'.txt');
        end
    end
    name = name(1);
    name = replace(name,'.','_');
    name = replace(name,' ','_');
    data = split(name,'_');
    date = string(data(1));
    plate = string(regexp(char(name),'[pP]late[_-]\d+','match'));
    plate = replace(plate,'-','_');
    plate = lower(strtrim(plate));
    if isempty(plate)
        plate = 'platexx';
    end
    temperatures = regexp(char(name),'[_](?<high>\d\d)[-](?<low>\d\d)','names');
    if isempty(temperatures)
        temperatures = [0,0];
    else
        temperatures = [str2double(temperatures.high),str2double(temperatures.low)];
    end
    name = replace(name,'-','_');
    if length(char(name))>58
        name = char(name);
        name = name(1:58);
        name = string(name);
    end
    try
    info_table = array2table([date,project_name,plate,temperatures(1),temperatures(2),well],'VariableNames',{'date','project','plate_ID','Th','Tl','well'});
    catch
    end
    name = string(name);
end