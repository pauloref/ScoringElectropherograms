function ScorewithHelp(obj,Distances,Threshold,CutOff,wavelet,WaveletThreshold)
%A function that does not score. It simply returns all wells as not scored,
%and all peaks as 0. 
fileName = obj.fileName;
Standard=obj.WellList.StandardData;
Signal=obj.WellList.SignalData;
time = obj.WellList.Wells(1,1).Read;
load('trained_model_pfux7.mat');
% Standard(Standard<Threshold)=0;
% CutStandard=Standard(:,CutOff:length(Standard));
% Distances=(Distances-Distances(1));



%window=round(min(diff(Distances))/1.5-1);

list = string(split(strjoin(obj.WellList.WellList),' '));

prominence = 0.025;
window_size = 20;

for k=list'
    i=obj.WellList.wellNumber(k);
    
    %We begin by initializing the peak position and height that will be
    %assigned as matrixes 4 by two filed with zeros. We also initialise
    %ScoreStatus as 0. 
    filtered_standard = removeBaseline(Signal(i,:),30);
    filtered_standard = filtered_standard/max(filtered_standard);
    primer_position = findPrimerPeak(filtered_standard,prominence);
    [PKS, LOCS, W, P]=findpeaks(filtered_standard,'MinPeakProminence',prominence);
    peak_data = zeros(length(LOCS),window_size*2+1+4); %peak data, peak height, width, prominence, relative location to primer peak
    
    for j=1:length(LOCS)
        LOC = LOCS(j);
        PK = PKS(j);
        Ww = W(j);
        Pp = P(j); 
        time_val = LOC - primer_position;
        peak_data(j,:) = [filtered_standard(i,LOC-window_size:LOC+window_size),PK,Ww,Pp,time_val];
    
    end
    labels = trained_Model_pfux7.predictFcn(peak_data);
    peaks = LOCS(find(labels));
    for n=1:length(peaks)
        pos = time(peaks(n));
        [a b]=PeakInSignal(Signal(i, (pos-Window):(pos+Window)));
        SignalPeaks(n,:)=[a b+pos-Window-1];
        [a b]=PeakInSignal(Stadard(i,(pos-Window):(pos+Window)));
        StandardPeaks(n,:)=[a b+pos-Window-1];
        PeakPos={Peak(peaks(n),Signal(i,:))};
        SigPeak={Peak(0,0)};
        obj.SignalPeaks{i}=SigPeak;
        obj.StandardPeaks{i}=PeakPos;
        obj.ScoreStatus(i)=0;
    end
    set(handles.StandardPeaks,'Data',StandardPeaks);
    set(handles.SignalPeaks,'Data',SignalPeaks);
    UpdateCurrentWell(handles);
    UpdateScoringInterface(handles);
    
end

