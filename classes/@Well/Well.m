classdef Well
    %Well is a class that stores the electropherogram from a single well,
    %output from CTCE
    
    %  Well stores the results of CTCE for a single cappilary. The class
    %  contains a matrix with the different reading chanels and the scan
    %  value at each read. It has the possibility of having the main signal
    %  marked as such as well as the standard. The methods it defines are
    %  plot...
    
    
    properties
        Data        %Matrix containing the signal intensity for each chanel at each time
        Read         %The read number associated with the data
        Current      %The current for each read
        
        
    end
    
  
    methods
        
        function obj=Well(filename)
            if nargin ==0
                obj.Data=[0 0 0 0 0 0];
                
            else
                Raw=ReadWellFromFile(filename);
                obj.Read=Raw(:,1);
                obj.Current=Raw(:,6);
                obj.Data=Raw(:,2:5); 
                
            end
            
        end
        
        function Chan = getChannel(obj,i)

            Chan=obj.Data(:,i);
        end
        
        Fig = plot(Obj,channels)
    end
    
end

