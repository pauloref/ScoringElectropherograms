function [trainedClassifier, peak_detection_accuracy] = SelfLearnKnnModel(trainingData,unlabelledData)
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData,unlabelledData)
% returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: A matrix with features and the last column corresponds
%      to labels [{0},{1}].
%      unlabelledData: A matrix with features but with no label column
%
%  Output:
%      trainedClassifier: a struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: a function to make predictions on new
%       data.
%
%      validationAccuracy: a double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Convert input to table
%% Split train and test data
labels = trainingData(:,end);
trainingData = (trainingData(:,1:end-1));
cv = cvpartition(size(trainingData,1),'HoldOut',0.3);
testData = trainingData(cv.test,:);
testResponse = labels(cv.test,:);
trainingData = trainingData(~cv.test,:);
trainResponse = labels(~cv.test,:);


% Train a classifier
% This code specifies all the classifier options and trains the classifier.
trainModel = @(predictors,response) fitcknn(predictors,response,'Distance', 'Euclidean', ...
    'Exponent', [], ...
    'NumNeighbors', 10, ...
    'DistanceWeight', 'SquaredInverse', ...
    'Standardize', true, ...
    'ClassNames', [0; 1]);


knnModel = trainModel(trainingData,trainResponse);
knnPredictFcn = @(x) predict(knnModel, x);
% Perform cross-validation
partitionedModel = crossval(knnModel, 'KFold', 5);

% Compute validation predictions
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% Compute test accuracy
yTestOriginal=knnPredictFcn(testData);
scoreTestOriginal = computeScore(yTestOriginal,testResponse);
%% Self learning: Insert test data 
% predict test data
unlabelledDataNew = unlabelledData;
xTrainNew = trainingData;
yTrainNew = trainResponse;
%Train model, predict unlabelled data. Select highest score and append to
%train data.
while ~isempty(unlabelledDataNew)
    knnModel = trainModel(xTrainNew,yTrainNew);
    [yPred,score]  = knnPredictFcn(unlabelledDataNew);
    maxScore = max(max(abs(score)));
    [trainCandidateIdxs,~] = find((score)==maxScore);
    xTrainNew = [xTrainNew;unlabelledDataNew(trainCandidateIdxs,:)];
    unlabelledDataNew(trainCandidateIdxs,:) = [];
    yTrainNew = [yTrainNew;yPred(trainCandidateIdxs,:)];
end
[yPredTest,scoresTest] = knnPredictFcn(testData);
peak_detection_accuracy = computeScore(testResponse,yPredTest);


trainedClassifier.predictFcn = @(x) knnPredictFcn(x);
% Add additional fields to the result struct
trainedClassifier.knnModel = knnModel;
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2019a.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new predictor column matrix, X, use: \n  yfit = c.predictFcn(X) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nX must contain exactly 24 columns because this model was trained using 24 predictors. \nX must contain only predictor columns in exactly the same order and format as your training \ndata. Do not include the response column or any columns you did not import into the app. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');
end

function score = computeScore(expected,predicted)
    confusionM = confusionmat(expected,predicted);
    score = confusionM(2,2)/(confusionM(2,2)+confusionM(1,2)+confusionM(2,1));
end