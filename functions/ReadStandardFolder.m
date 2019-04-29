function Output  = ReadStandardFolder( Folder,Standard,Signal)
if(nargin==1)
    Standard=2;
    Signal=3;
end
%ReadStandardWell creates a WellGroup class by reading all Text files named
%as wells (A to H followed by a number from 1 to 12).
%   Detailed explanation goes here
CurrentDir=cd;  %remember curent folder
cd(Folder); %change to folder specified by user

%All the files present in the directory are read and used to create a list
%of well names and files that will be imported.
welllist=regexp(ls(),'([ABCDEFGH]\d+).txt','tokens');
filelist=regexp(ls(),'([ABCDEFGH]\d+).txt','match');
%We now use the constructor of the class WellGroup to create a well group
%from all the text files that were present in the directory
Output=WellGroup(filelist,welllist,Standard,Signal);

cd(CurrentDir); %move back to the original directory
%plot(handles.Project.StandardData');
%We now update the listbox WellList to contain the name of all the wells
%that were used

end

