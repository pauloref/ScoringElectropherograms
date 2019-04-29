function ScoreWithPeakFinderAndDistances(obj,Distances,Threshold,CutOff,wavelet,WaveletThreshold)
%A functions that scores peaks from electropherograms the function peakfinder already
%implemented in matlab.
%It can be called upon as an argument by the DefaultScore function, a method
%of the Score class.


Standard=obj.WellList.StandardData;
Signal=obj.WellList.SignalData;
Standard(Standard<Threshold)=0;
CutStandard=Standard(:,CutOff:length(Standard));
Distances=(Distances-Distances(1));




window=round(min(diff(Distances))/1.5-1);
for k=[obj.WellList.WellList{:}]
    i=obj.WellList.wellNumber(k);
    
    %We begin by initializing the peak position and height that will be
    %assigned as matrixes 4 by two filed with zeros.
    PeakPos=zeros(4,2);
    SigPeak=zeros(4,2);
    obj.SignalPeaks{i}=SigPeak;
    obj.StandardPeaks{i}=PeakPos;
    
    %We use the matlab implemented function to analyze all peaks present
    [pks, loc, width, proem]=findpeaks(CutStandard(i,:));
    
    %If no peaks is proeminent enough, the standard is considered too bad
    %to be used and the well is not scored.
    if(max(proem)<=WaveletThreshold)
        obj.ScoreStatus(i)=0;
        continue
    end
    
    %We now separate the four most proeminent peaks present in the cut
    %standard
    
    [SortedProem, SortedLoc]=sort(proem,'descend');
    Locs=sort(SortedLoc(1:4),'ascend');
    %We now place the four selected peaks into their respective positions
    %and use them to identify the corresponding signal peak
    for j=1:4
        %place the peak j into it's signal peak matrix
        a=pks(Locs(j));
        b=loc(Locs(j))+CutOff;
        PeakPos(j,:)=[a b]; %place them in the matrix
        pk=PeakPos(j,2);%update pk to be the standard peak found and find the coresponding
        %signal peak
        [a b]=PeakInSignal(Signal(i,(pk-window):(pk+window)) );
        SigPeak(j,:)=[a b+pk-window];
    end
    
    %Save standard peaks
    obj.StandardPeaks{i}=PeakPos;
    %If the Signal peak is too low mark the well as not scored
    if(max(SigPeak(:,1)<500))
        obj.ScoreStatus(i)=0;
        continue
    end
    %Save signal peaks
    obj.SignalPeaks{i}=SigPeak;
    %Mark the well as scored
    obj.ScoreStatus(i)=1;
    
end

end

