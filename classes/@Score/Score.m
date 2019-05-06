classdef Score < handle
    %This class contains the result of scoring a WellList
    %   It is the class that will be handled by the Scoring Interface for
    %   review. It therefore needs to interface between the results of the
    %   Scoring function and the user.
    %This class needs to be a handle as it is going to be modifying itself
    %as the scoring proceeds.
    properties
        WellList %The well list
        PeakNumbers %The number of peaks detected in each well
        ScoreStatus %A vector of booleans. If true the corresponding well has been scored
        StandardPeaks %A matrix of peaks containing the Standard Peaks
        SignalPeaks %A matrix of peaks containing the Signal Peaks
        MutantFraction %A list of cells containig the matrixes for the mutant fraction
    end
    
    properties (Dependent = true )
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
            obj.MutantFraction=cell(1,welllist.N);
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
            %this function will attempt to return the mutant fraction in
            %each well. The size of the output will depend on the number of
            %mutants identified in the well.
            for k = [obj.WellList.WellList{:}]%we loop through each well
                i=obj.WellList.wellNumber((k)); %and find out the well number
                if(~(obj.ScoreStatus(i)) || isempty(obj.SignalPeaks{i}) )
                    %If the well is marked as not score, or has no signal
                    %peak, we set the Mutant fraction as NaN, and continue
                    obj.MutantFraction{i}=NaN;
                    continue;
                end
                %Else, we take all the peaks in the signal, and attempt to
                %calculate the mutant fraction
                Peaks=obj.SignalPeaks{i};
                %the Mutant fraction calculation depends on the number of
                %peaks found
                switch length(Peaks)
                    case 1
                        obj.MutantFraction{i}=[1];
                    case 2
                    case 3
                    case 4
                        MF=( Peaks{1}.Area+Peaks{3}.Area/2+Peaks{4}.Area/2)/...
                            (Peaks{1}.Area+Peaks{2}.Area+Peaks{3}.Area+Peaks{4}.Area);
                        obj.MutantFraction{i}=[MF 1-MF];
                    case 5
                    case 6
                    case 7
                    case 8
                    case 9
                end
                
            end
            MutantFraction=obj.MutantFraction;
        end
        
        function SPM=SignalPeakMatrix(obj,WellNumber)
            %a function that returns the Signal peaks in the Score. If the
            %well number is specified, it will return a matrix containing
            %only the signal peaks in that speciffic well.
            %If the well number is not specified, it will return an array
            %of cells, each cell will contain the matrix of Peaks position
            %corresponding to each well.
            if(WellNumber>0)
                NP=length(obj.SignalPeaks{WellNumber});
                SPM=zeros(NP,2);
                for k= 1:NP
                    obj.SignalPeaks{WellNumber};
                    SPM(k,2)=obj.SignalPeaks{WellNumber}{k}.X;
                    SPM(k,1)=obj.SignalPeaks{WellNumber}{k}.Y;
                end
            end
        end
        
        function SPM=StandardPeakMatrix(obj,WellNumber)
            %a function that returns the Signal peaks in the Score. If the
            %well number is specified, it will return a matrix containing
            %only the signal peaks in that speciffic well.
            %If the well number is not specified, it will return an array
            %of cells, each cell will contain the matrix of Peaks position
            %corresponding to each well.
            if(WellNumber>0)
                NP=length(obj.StandardPeaks{WellNumber});
                SPM=zeros(NP,2);
                for k= 1:NP
                    SPM(k,2)=obj.StandardPeaks{WellNumber}{k}.X;
                    SPM(k,1)=obj.StandardPeaks{WellNumber}{k}.Y;
                end
            end
        end
        function AssignSignalPeaksFromMatrix(obj,WellNumber,PeakData)
            NPeaks=size(PeakData,1);
            PeakContainer=cell(1,NPeaks);
            for k=1:NPeaks
                PeakContainer{k}=Peak(PeakData(k,2),obj.WellList.Wells(WellNumber).Data(:,obj.WellList.Signal));
            end
            obj.SignalPeaks{WellNumber}=PeakContainer;
        end
        function AssignStandardlPeaksFromMatrix(obj,WellNumber,PeakData)
            NPeaks=size(PeakData,1);
            PeakContainer=cell(1,NPeaks);
            for k=1:NPeaks
                PeakContainer{k}=Peak(PeakData(k,2),obj.WellList.Wells(WellNumber).Data(:,obj.WellList.Standard));
            end
            obj.StandardPeaks{WellNumber}=PeakContainer;
        end
    end
    
end

