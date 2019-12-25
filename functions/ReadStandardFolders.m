function Output  = ReadStandardFolders( Folders,Standard,Signal)
if(nargin==1)
    Standard=2;
    Signal=3;
end
%ReadStandardWell creates a WellGroup class by reading all Text files named
%as wells (A to H followed by a number from 1 to 12).
%   Detailed explanation goes here
% initialize well group
Output(2) = WellGroup;
% get file names

for i=1:length(Folders)
    Folder = Folders(i);
    if ismac()
        filename = split(Folder,'/');
    else
        filename = split(Folder,'\');
    end
    filename = filename(end-1);
    CurrentDir=cd;  %remember curent folder
    cd(Folder); %change to folder specified by user
    
    %All the files present in the directory are read and used to create a list
    %of well names and files that will be imported.
    output_str = ls();
    if ~ismac
        filelist = (cellstr(output_str(3:end,:)));
        welllist = (cellstr(output_str(3:end,1:3)));
        %filelist(1:2) = []; welllist(1:2) = [];
    else
        welllist=regexp(string(cellstr(output_str)'),'([ABCDEFGH]\d+).txt','tokens');
        filelist=regexp(string(cellstr(output_str)'),'([ABCDEFGH]\d+).txt','match');
        [val,idx] = sort(cellstr(welllist));
        welllist = cellstr([welllist{idx}]);
        filelist = filelist(idx);
        
        
    end
    
    
    %We now use the constructor of the class WellGroup to create a well group
    %from all the text files that were present in the directory
    Output(i)=WellGroup(filelist,filename,welllist,Standard,Signal);
    
    cd(CurrentDir); %move back to the original directory
    %plot(handles.Project.StandardData');
    %We now update the listbox WellList to contain the name of all the wells
    %that were used
end
end

