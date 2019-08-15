function DefaultScore(obj,ScoreFunction,Distances,Threshold,CutOff,wavelet,WaveletThreshold)
%DefaultScore performs th default scoring for a list of wells.
%   Detailed explanation goes here
current_dir = split(pwd,'\');
current_dir = current_dir(end);
if ~strcmp(current_dir,'ScoringFunctions')
    cd('functions/ScoringFunctions');
end
ScoreFunction(obj,Distances,Threshold,CutOff,wavelet,WaveletThreshold)

end

