classdef WellGroup
    %WellGroup Contains list of wells, name of directory
    %   Detailed explanation goes here
    
    properties
        Wells   %The list of wells contained by the WellGroup
        Signal   %The channel corresponding to the Signal in the group
        Standard %The channel corresponding to the Standard (if any)
        WellList %A list of the names of the wells in the Wells property
    end
    
    properties (Dependent = true )
        N   %The number of wells in the WellGroup
        SignalData %The matrix containing all the signals
        StandardData %The matrix containing all the Standards
        WellNames
    end
    
    
    methods
        %First we define a constructor class
        function obj=WellGroup(fileList,wellList,signal,standard)
            if nargin
                switch(nargin)
                    
                    case 1
                        wellList=regexp(filelist,'.txt','split');
                        signal = 2;
                        standard=0;
                    case 2
                        signal = 2;
                        standard=0;
                    case 3
                        standard=0;
                end
                obj.Wells=Well.empty;
                
                for i=1:length(fileList)
                    obj.Wells(i)=Well(fileList{i});
                end
                
                obj.WellList=wellList;
                obj.Signal=signal;
                obj.Standard=standard;
            end
        end
        
        
        
        %Are now defined the functions that return the dependent properties
        %First is N
        function N = get.N(obj)
            N=length(obj.WellList);
        end
        
        function Number = wellNumber(obj,well)
            Number=find(ismember(string(obj.WellList),well));
        end
        
       
        function Well = returnWell(obj,well)
            %obj.returnWell allows the wells to be returned by calling
            %their names
            
                Well = obj.Wells(find(ismember(obj.WellList,well)));
            end
        
        
        
        %Then Signal Data
        function Matrix = get.SignalData(obj)
            for i=1:obj.N
                W=obj.returnWell(obj.WellList{i});
                Matrix(i,:)=W.getChannel(obj.Signal);
            end
            
        end
        
        %And Standard data
        function Matrix = get.StandardData(obj)
            for i=1:obj.N
                W=obj.returnWell(obj.WellList{i});
                Matrix(i,:)=W.getChannel(obj.Standard);
            end
            
        end
        
        function Names = get.WellNames(obj)
            for i=1:obj.N
            %Names(i,:)=cell2mat(obj.WellList{i});
            Names(i,:)=(obj.WellList{i});
            end
        end
    end
    
end

