classdef WellGroup
    %WellGroup Contains list of wells, name of directory
    %   Detailed explanation goes here
    
    properties
        Wells   %The list of wells contained by the WellGroup
        Signal   %The channel corresponding to the Signal in the group
        Standard %The channel corresponding to the Standard (if any)
        WellList %A list of the names of the wells in the Wells property
        FileName
        Tl       double 
        Th       double 
    end
    
    properties (Dependent = true )
        N   %The number of wells in the WellGroup
        SignalData %The matrix containing all the signals
        StandardData %The matrix containing all the Standards
        WellNames        
    end
    
    
    methods
        %First we define a constructor class
        function obj=WellGroup(fileList,filename,wellList,signal,standard)
            if nargin
                switch(nargin)
                    
                    case 1
                        wellList=regexp(filelist,'.txt','split');
                        signal = 2;
                        standard=0;
                        filename = 'nan';
                    case 2
                        wellList=regexp(filelist,'.txt','split');
                        signal = 2;
                        standard=0;
                    case 3
                        signal = 2;
                        standard=0;
                    case 4
                        standard=0;
                end
                obj.Wells=Well.empty;
                
                for i=1:length(fileList)
                    obj.Wells(i)=Well(fileList{i},filename,...
                                       string(wellList(i)));
                end
                
                obj.WellList=wellList;
                obj.Signal=signal;
                obj.Standard=standard;
                obj.FileName = filename;
            end
        end
        
        
        
        %Are now defined the functions that return the dependent properties
        %First is N
        function N = get.N(obj)
            N=length(obj.WellList);
        end
%       
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
        function obj = set.Th(obj,th)
           obj.Th = th;
           for ii = 1:length(obj.Wells)
              obj.Wells(ii).Th = th; 
           end
        end
        function obj = set.Tl(obj,tl)
            obj.Tl = tl;
            for ii = 1:length(obj.Wells)
                obj.Wells(ii).Tl = tl;
            end
        end
        
        function obj = ToggleWellOrder(obj)
            number_idx=[1:12:96,...
                2:12:96,...
                3:12:96,...
                4:12:96,...
                5:12:96,...
                6:12:96,...
                7:12:96,...
                8:12:96,...
                9:12:96,...
                10:12:96,...
                11:12:96,...
                12:12:96];
            letter_idx=[1:8:96,...
                2:8:96,...
                3:8:96,...
                4:8:96,...
                5:8:96,...
                6:8:96,...
                7:8:96,...
                8:8:96];
            
            if strcmp(obj.WellList{2},'A02')   %swap indeces
                obj.WellList = obj.WellList(number_idx);
                obj.Wells = obj.Wells(number_idx);
            else
                obj.WellList = obj.WellList(letter_idx);
                obj.Wells = obj.Wells(letter_idx);
            end
            
        end
%         function fileName = get.FileName(obj)
%             fileName = obj.FileName;
%         end
    end
    
end

