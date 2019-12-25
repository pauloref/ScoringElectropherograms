function net = train_nn(peak_data)
%% Train Neural Network
% to train the neural network it is necessary to have an input table
% (train_data), a time values data (time_values), and a 
size_nn = size(peak_data,1);
size_input = size(peak_data,2)-1;
% layers = [
%     sequenceInputLayer(size_input,"Name","single_peak_input")
%     fullyConnectedLayer(20,"Name","fc_1")
%     reluLayer("Name","relu")
%     fullyConnectedLayer(2,"Name","fc_2")
%     softmaxLayer("Name","softmax")
%     classificationLayer("Name","classoutput")];
layers = [
    imageInputLayer([2 31 1],"Name","imageinput")
    convolution2dLayer([2 4],3,"Name","Convolution 1","Padding","same")
    maxPooling2dLayer([1 2],"Name","maxpool_1","Padding","same","Stride",[1 2])
    eluLayer(1,"Name","elu_1")
    convolution2dLayer([1 3],3,"Name","conv_2","Padding","same")
    maxPooling2dLayer([1 2],"Name","maxpool_2","Padding","same","Stride",[1 2])
    eluLayer(1,"Name","elu_2")
    convolution2dLayer([1 6],2,"Name","conv_3","Padding","same")
    flattenLayer("Name","flatten")
    convolution2dLayer([1 18],1,"Name","conv_1d","Padding","same")
    flattenLayer("Name","flatten_output")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
%[tr_set,te_set] = splitEachLabel(table(peak_data),size_nn,'randomize');
if nargin<2
x_tr = peak_data;
y_tr = labels;
else
    x_tr = peak_data(:,1,:,2:end);
    y_tr = labels;
end
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
    'InitialLearnRate',0.05, ...
    'MaxEpochs',500, ...
    'Shuffle','every-epoch', ...
    'Verbose',true, ...
    'Plots','training-progress');
%'ValidationData',table(x_te,y_te), ...
    %'ValidationFrequency',30, ...);
%options = trainingOptions('sgdm', 'Plots', 'training-progress');
%        [net,info] = trainNetwork(XTrain, YTrain, lgraph, options);
net = trainNetwork(x_tr',categorical(y_tr)',layers,options);