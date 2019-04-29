function [output] = ReadWellFromFile(filename)

    A=regexp(fileread(filename),'(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+\n','match')';
    for(i=1:size(A))
         output(i,:)=str2num(A{i}(:)');
    end
    
end