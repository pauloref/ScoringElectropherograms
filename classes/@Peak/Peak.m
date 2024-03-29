classdef Peak < handle
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
        Baseline %The peak baseline
    end
    
    methods
        function obj = Peak(x,Signal)
            %PEAK Construct an instance of peak, from its position, and a
            %Signal
            %   Detailed explanation goes here
            Derivate=diff(Signal);
            if(isnumeric(x) && x>50)
                obj.X=x; %we set the position of the maximum to x
                obj.Y=Signal(x); %So obviously the maximum height is just the signal value at that position
                %Following is provisory, will be updated
                %@TODO update the following to accurately find start and end,
                
                %We now look for the start of the signal. We do that by
                %going back from the position x, and checking the value of
                %the derivative.
                for i=(x-1):-1:1
                    if(Derivate(i)<0)
                        obj.Start=i;
                        break;
                    end
                end
                
                for i=x:length(Signal)
                    if(Derivate(i)>0)
                        obj.End=i;
                        break;
                    end
                end
                
                
                %We now compute the Area of the peak, which is the sum of
                %all signal values between start and end.
                obj.Area = sum(Signal(obj.Start:obj.End));
                %And the baseline of the peak is the minimal value of the
                %signal in the peak.
                obj.Baseline=min(Signal(obj.Start:obj.End));
            else
                obj.X=0;
                obj.Y=0;
                obj.Start=0;
                obj.End=0;
                obj.Area = 0;
                obj.Baseline = 0;
            end
        end
        
        function Value=get(obj,Prop)
            if(isprop(obj,Prop))
                Value=obj.(Prop);
            else
                error(strcat('Input must be a property type of object Peak \n input is:',Prop));
            end
        end
        %
        %         function X=get.X(obj)
        %             X=obj.X;
        %         end
        %         function Y=get.Y(obj)
        %             Y=obj.Y;
        %         end
        %         function Area=get.Area(obj)
        %             Area=obj.Area;
        %         end
        %
    end
end


