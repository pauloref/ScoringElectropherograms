function ScorepcaKnnModel(obj,Distances,Threshold,CutOff,wavelet,WaveletThreshold)
%Scores using bagged trees. Bagged Trees were trained with gel test, pfux7
%and standard library signal input. 

fileName = obj.fileName;
Standard=obj.WellList.StandardData; %get standard signal
Signal=obj.WellList.SignalData; %get signal
time = obj.WellList.Wells(1,1).Read; %get time
load('trainPcaKnn3.mat'); % load model

model = trainPcaKnn3;
%obj.SignalPeaks=squeeze(obj.SignalPeaks);
%obj.StandardPeaks=squeeze(obj.StandardPeaks);
%obj.ScoreStatus = squeeze(obj.ScoreStatus);

Window=round(min(diff(Distances))/1.5-1);

list = string(split(strjoin(obj.WellList.WellList),' '));

prominence = 0.05;
window_size = 20;

for k=list'
    i=obj.WellList.wellNumber(k);
    
    %We begin by initializing the peak position and height that will be
    %assigned as matrixes 4 by two filed with zeros. We also initialise
    %ScoreStatus as 0. 
    filtered_standard = PreprocessArray(Signal(i,:));
    %filtered_standard = removeBaseline(Signal(i,:),30);
    %filtered_standard = filtered_standard/max(filtered_standard);
    primer_position = findPrimerPeak(filtered_standard,prominence);
    
    [PKS, LOCS, W, P]=findpeaks(filtered_standard,'MinPeakProminence',prominence);
    if check_blank(LOCS,W)
        continue;
    end
    peak_data = zeros(length(LOCS),window_size*2+1+4); %peak data, width, prominence, relative location to primer peak
    peak_count = length(LOCS);
    for j=1:peak_count
        LOC = LOCS(j);
        PK = PKS(j);
        Ww = W(j);
        Pp = P(j); 
        time_val = LOC - primer_position;
        try
        shape_features =  filtered_standard(LOC-window_size:LOC+window_size);
        shape_features = shape_features/max(shape_features); % collect only shape
        peak_data(j,:) = [time_val,Pp,peak_count,j,shape_features];
        catch
           continue; 
        end
    
    end
    pk_data_table = array2table(peak_data);
    pk_data_table.Properties.VariableNames(1:4) = {'relative_time','prominence','peak_count','peak_pos'};
    pk_data_table.Properties.VariableNames(5:end) = matlab.internal.datatypes.numberedNames('normalized_signal',1:41);
    labels = model.predictFcn(pk_data_table); %predict output from model
    peaks = LOCS(find(labels));
    PeakPos = cell(1,length(peaks));
    for n=1:length(peaks)
        pos = time(peaks(n));
        [a b]=PeakInSignal(Signal(i, (pos-Window):(pos+Window)));
        SignalPeaks(n,:)=[a b+pos-Window-1];
        [a b]=PeakInSignal(Standard(i,(pos-Window):(pos+Window)));
        StandardPeaks(n,:)=[a b+pos-Window-1];
        PeakPos(n)={Peak(peaks(n),Signal(i,:))};        
    end
    obj.SignalPeaks{i}=PeakPos;
    obj.StandardPeaks{i}=PeakPos;
    obj.ScoreStatus(i)=1;
    %set(handles.StandardPeaks,'Data',StandardPeaks);
    %set(handles.SignalPeaks,'Data',SignalPeaks);
    %UpdateCurrentWell(handles);
    %UpdateScoringInterface(handles);
    
end

