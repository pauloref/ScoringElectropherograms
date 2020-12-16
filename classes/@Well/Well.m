classdef Well
    %Well is a class that stores the electropherogram from a single well,
    %output from CTCE
    
    %  Well stores the results of CTCE for a single cappilary. The class
    %  contains a matrix with the different reading chanels and the scan
    %  value at each read. It has the possibility of having the main signal
    %  marked as such as well as the standard. The methods it defines are
    %  plot...
    
    
    properties
        Data        double   %Matrix containing the signal intensity for each chanel at each time
        Read        double    %The read number associated with the data
        Current     double   %The current for each read
        FileName    string
        Primer      string
        WellId      string
        Peaks       cell
        MutantFraction double 
    end
    
  
    methods
        
        function obj=Well(textFile,directoryName,wellId,primerName)
            if nargin>3
                obj.Primer = primerName;
            end
            if nargin>2
                obj.WellId = wellId;
            end
            if nargin >1
                obj.FileName = directoryName;
            end
            if nargin >0
                Raw=ReadWellFromFile(textFile);
                obj.Read=Raw(:,1);
                obj.Current=Raw(:,6);
                obj.Data=Raw(:,2:5); 
            else
                obj.Data=[0 0 0 0 0 0];     
            end            
        end
        
        function Chan = getChannel(obj,i)

            Chan=obj.Data(:,i);
        end
        function wellPeak = toWellPeaks(obj)
            wellPeak = struct('FileName',obj.FileName,...
                              'Primer',obj.Primer,...
                              'WellId',obj.WellId,...
                              'MutantFraction',obj.MutantFraction,...
                              'Peaks',[obj.Peaks{:}]);                       
        end
        function wellSignal = toWellSignal(obj)
           wellSignal = struct('Signals',obj.Data',...
                               'Time',obj.Read,...
                               'Current',obj.Current,...
                               'FileName',obj.FileName);
           
        end
        
        Fig = plot(Obj,channels)
    end
    
end

