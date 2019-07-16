function [output] = ReadWellFromFile(filename)
    file = dir(filename);
    content = importdata(file.name);
    output = content.data(:,[1,3,5,7,9,11]);
end