function name = parse_name (input)
    
    name = split(input,'.csv');
    if length(name)<2
        name = split(input,'.xls');
        if length(name)<2
            name = split(input,'.txt');
        end
    end
    name = name(1);
    %name = strjoin(['t',name]);
    name = replace(name,'.','_');
    name = replace(name,' ','_');
    name = replace(name,'-','_');
    if length(char(name))>58
        name = char(name);
        name = name(1:58);
        name = string(name);
    end
end