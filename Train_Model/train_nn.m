function net = train_nn(peak_data,labels)
%% Train Neural Network
% to train the neural network it is necessary to have an input table
% (train_data), a time values data (time_values), and a 
size_nn = size(peak_data,1);
size_input = size(peak_data,2);
% layers = [
%     sequenceInputLayer(size_input,"Name","single_peak_input")
%     fullyConnectedLayer(20,"Name","fc_1")
%     reluLayer("Name","relu")
%     fullyConnectedLayer(2,"Name","fc_2")
%     softmaxLayer("Name","softmax")
%     classificationLayer("Name","classoutput")];
% layers = [
%     imageInputLayer([2 32 1],"Name","imageinput")
%     convolution2dLayer([2 4],3,"Name","conv","Padding","same")
%     maxPooling2dLayer([1 4],"Name","maxpool","Padding","same","Stride",[1 4])
%     eluLayer(1,"Name","elu")
%     dropoutLayer(0.5,"Name","dropout")
%     fullyConnectedLayer(2,"Name","fc")
%     softmaxLayer("Name","softmax")
%     classificationLayer("Name","classoutput")];
layers = [
    imageInputLayer([2 size_input 1],"Name","imageinput")
    convolution2dLayer([2 5],3,"Name","conv_1","Padding","same")
    maxPooling2dLayer([1 2],"Name","maxpool_1","Padding","same","Stride",[1 2])
    eluLayer(1,"Name","elu_1")
    convolution2dLayer([1 5],3,"Name","conv_2","Padding","same")
    maxPooling2dLayer([1 2],"Name","maxpool_2","Padding","same","Stride",[1 2])
    eluLayer(1,"Name","elu_2")
    convolution2dLayer([1 5],3,"Name","conv_3","Padding","same")
    eluLayer(1,"Name","elu_3")
    dropoutLayer(0.5,"Name","dropout")
    fullyConnectedLayer(2,"Name","fc")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];

%[tr_set,te_set] = splitEachLabel(table(peak_data),size_nn,'randomize');
x_tr = peak_data;
y_tr = categorical(labels');

%y_f = ones(length(y),1);
%y = (categorical([y_f-y,y])); 
%z = cell(size(y,1),1);
%for i=1:size(y,1)
%   z{i} = y(i,:);  
%end
%[x_tr,x_te,y_tr,y_te] = train_test_split(x,y,0.8);

%x_te = te_set(:,end-1);
%y_te = te_set(:,end);
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.1, ...
    'MaxEpochs',500, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.2, ...
    'LearnRateDropPeriod',100, ...
    'Shuffle','every-epoch', ...
    'Verbose',true, ...
    'Plots','training-progress');
%'ValidationData',table(x_te,y_te), ...
    %'ValidationFrequency',30, ...);
%options = trainingOptions('sgdm', 'Plots', 'training-progress');
%        [net,info] = trainNetwork(XTrain, YTrain, lgraph, options);
net = trainNetwork(x_tr,y_tr,layers,options);