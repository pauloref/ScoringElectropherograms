function [name,info_table] = parse_name (input_name,well)
    
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
    primer = string(data(2));
    if ~~ismember('-',primer)
        primer = join([string(data(2)),string(data(3))],'-');
    end
    plate = string(regexp(char(name),'plate\d+','match'));
    if isempty(plate)
        plate = 'platexx';
    end
    temperatures = regexp(char(name),'[_](?<high>\d\d)[-](?<low>\d\d)','names');
    temperatures = [str2double(temperatures.high),str2double(temperatures.low)];
    name = replace(name,'-','_');
    if length(char(name))>58
        name = char(name);
        name = name(1:58);
        name = string(name);
    end
    try
    info_table = array2table([date,primer,plate,temperatures(1),temperatures(2),well],'VariableNames',{'date','primer_ID','plate_ID','Th','Tl','well'});
    catch
    end
    name = string(name);
end