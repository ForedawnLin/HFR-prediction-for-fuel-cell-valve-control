% clc 
clear all 
clc 

%%%%% Extract data %%%%%
train_file='../software/data/train_data.mat';
train_set=load(train_file);
train_set=train_set.train_data;


%%% create LSTM feed-in format %%% 
skip=[19];
time_step=[10];
shuffle=1;
filter=1;
[train_feature,train_Y,train_feature_array,train_Y_array]= create_LSTM_cell(train_set,time_step,shuffle,filter,skip);
filePath=['model/','model_1'];
mkdir(filePath);
Shape=size(train_feature{1});


%%%% train LSTM %%%% 
maxEpochs = 2000;
miniBatchSize = 64;
numFeatures = Shape(1);
LSTMUnits1 =512;
hidden1=256;
numResponses = time_step;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(LSTMUnits1,'OutputMode','sequence')
    fullyConnectedLayer(hidden1)
    reluLayer
    fullyConnectedLayer(1) 
    regressionLayer];

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'GradientThreshold',1, ...
    'Verbose',1, ...
    'CheckpointPath',filePath, ...
    'Plots','none');
net = trainNetwork(train_feature,train_Y,layers,options);


       
        
