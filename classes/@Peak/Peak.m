classdef Peak
    %PEAK is a class that stores the information for a single peak. It will
    %also contain basic function that act on the peak, such as calculating
    %its area, and plotting it.
    %   Detailed explanation goes here
    
    properties
        X %The X position of the peak maximum
        Y %Maximum Peak Height
        Start %start of the Peak
        End %End of the peak
        Area %Peak Area
    end
    
    methods
        function obj = Peak(x,Signal)
            %PEAK Construct an instance of peak, from its position, and a
            %Signal
            %   Detailed explanation goes here
            if(x>100)
                obj.X=x; %we set the position of the maximum to x
                obj.Y=Signal(x); %So obviously the maximum height is just the signal value at that position
                %Following is provisory, will be updated
                %@TODO update the following to accurately find start and end,
                %then calculate Area
                obj.Start=x-10;
                obj.End=x+10;
                obj.Area = sum(Signal(obj.Start:obj.End));
            else
                obj.X=0;
                obj.Y=0;
                obj.Start=0;
                obj.End=0;
                obj.Area = 0;
            end
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

