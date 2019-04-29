function ScoreWaveletWithDistances(obj,Distances,Threshold,CutOff,wavelet,WaveletThreshold)
%A functions that scores peaks from electropherograms using wavelets. It
%can be called upon as an argument by the DefaultScore function, a method
%of the Score class.


Standard=obj.WellList.StandardData;
Signal=obj.WellList.SignalData;
Standard(Standard<Threshold)=0;
CutStandard=Standard(:,CutOff:length(Standard));
Distances=(Distances-Distances(1));




window=round(min(diff(Distances))/2-2);
for k=[obj.WellList.WellList{:}]
    i=obj.WellList.wellNumber(k);
    
    %We begin by initializing the peak position and height that will be
    %assigned as matrixes 4 by two filed with zeros.
    PeakPos=zeros(4,2);
    SigPeak=zeros(4,2);
    obj.SignalPeaks{i}=SigPeak;
    obj.StandardPeaks{i}=PeakPos;
    
    %Perform a wavelet transform with smoothing
    c=cwt(diff(smooth(CutStandard(i,:),5)),(1:150)/10,wavelet);
    
    %We now seek to indentify the first peak above the WaveletThreshold
    cc=find(c>=WaveletThreshold); %all the positions above threshold
    %If no peak is above the threshold we set the well as not scored and
    %move to the next one
    if(isempty(cc))
        obj.ScoreStatus(i)=0;
        continue
    end
    
    %We now find the column (corresponding to the x axis) where the first
    %peak is.
    SIZ = size(c);
    COL = round(min(cc)/SIZ(1));
    %If the value is empty, or exeeds the X limit, the well is marked as
    %not scored and we move on
    if((COL+Distances(4))>length(Standard) || isempty(COL))
        obj.ScoreStatus(i)=0;
        continue
    end
    
    
    
    for j=1:4
        pk=Distances(j)+(COL+CutOff); %pk is the suspected peak position.
        %Find the peaks in the window around pk
        PeakInSignal(Standard(i,(pk-window):(pk+window)));
        PeakPos(j,:)=PeakInSignal(Standard(i,(pk-window):(pk+window)) );  
        PeakPos(j,2)=+pk; %add pk to the index
        pk=PeakPos(j,2);%update pk to be the standard peak found
        SigPeak(j,:)=PeakInSignal(Signal(i,(pk-window):(pk+window)) );
        SigPeak(j,2)=+pk;
        
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

