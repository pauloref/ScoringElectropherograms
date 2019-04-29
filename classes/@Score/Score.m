classdef Score < handle
    %This class contains the result of scoring a WellList
    %   Detailed explanation goes here
    %This class needs to be a handle as it is going to be modifying itself
    %as the scoring proceeds.
    properties
        WellList %The well list
        PeakNumbers %The number of peaks detected in each well
        ScoreStatus %A vector of booleans. If true the corresponding well has been scored
        StandardPeaks
        SignalPeaks
        %Two matrixes containing signal peaks X and Y positions of each well
        %PeaksX
        %PeaksY
        
        %Two matrixes containing Standard peaks X and Y positions of each well
        %StdX
        %StdY
    end
    
    properties (Dependent = true )
        MutantFraction
        PeakHeights
        PeakPositions
    end
    
    methods
        
        %We first deine a default constructor
        function obj=Score(welllist)
            obj.WellList=welllist;
            obj.ScoreStatus=zeros(1,welllist.N);
            obj.PeakNumbers=zeros(1,welllist.N);
            %Peaks=cell(obj.WellList.N,1);
            obj.SignalPeaks=cell(1,welllist.N);
            obj.StandardPeaks=cell(1,welllist.N);
            
        end
        
        %and define a default score method. This method is resposible for
        %scoring the results and storing them inside the class upon which it
        %is being called.
        
        DefaultScore(obj,ScoreFunction,Distances,Threshold,CutOff,wavelet,WaveletThreshold)
        %We now define a function that returns the standard peaks by well
        
        
        %We now define the functions that return the dependent properties
        %of a Score class object
        
        %Mutant Fraction
        function MutantFraction=get.MutantFraction(obj)
            
            for k = [obj.WellList.WellList{:}]
                i=obj.WellList.wellNumber((k));
                
                if(~(obj.ScoreStatus(i)) || isempty(obj.SignalPeaks{i}) )
                    MutantFraction(i)=NaN;
                    continue;
                end
                Peaks=obj.SignalPeaks{i};
                MutantFraction(i)=(Peaks(1,1)+Peaks(3,1)/2+Peaks(4,1)/2)/...
                    (Peaks(1,1)+Peaks(2,1)+Peaks(3,1)+Peaks(4,1));
            end
        end
        
    end
    
end

