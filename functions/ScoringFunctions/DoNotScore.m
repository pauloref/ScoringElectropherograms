function DoNotScore(obj,Distances,Threshold,CutOff,wavelet,WaveletThreshold)
%A function that does not score. It simply returns all wells as not scored,
%and all peaks as 0. 
fileName = obj.fileName;
Standard=obj.WellList.StandardData;
Signal=obj.WellList.SignalData;
Standard(Standard<Threshold)=0;
CutStandard=Standard(:,CutOff:length(Standard));
Distances=(Distances-Distances(1));




window=round(min(diff(Distances))/1.5-1);

list = string(split(strjoin(obj.WellList.WellList),' '));


for k=list'
    i=obj.WellList.wellNumber(k);
    
    %We begin by initializing the peak position and height that will be
    %assigned as matrixes 4 by two filed with zeros. We also initialise
    %ScoreStatus as 0. 
    PeakPos={Peak(0,0)};
    SigPeak={Peak(0,0)};
    obj.SignalPeaks{i}=SigPeak;
    obj.StandardPeaks{i}=PeakPos;
    obj.ScoreStatus(i)=0;
end

