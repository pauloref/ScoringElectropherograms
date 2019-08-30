function DefaultScore(obj,ScoreFunction,Distances,Threshold,CutOff,wavelet,WaveletThreshold)
%DefaultScore performs th default scoring for a list of wells.
%   Detailed explanation goes here
if ismac
    current_dir = split(pwd,'/');
else
current_dir = split(pwd,'\');
end
current_dir = current_dir(end);
if ~strcmp(current_dir,'ScoringFunctions')
    cd('functions/ScoringFunctions');
end
ScoreFunction(obj,Distances,Threshold,CutOff,wavelet,WaveletThreshold)

end

