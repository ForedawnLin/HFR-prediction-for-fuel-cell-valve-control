% n_LSTM_units=2048; %% LSTM cell state size 
% T=10; %%% LSTM model length
%%% read paramters %%% 
%%% lstm params %%%
model_path='../../candidate_models/12_puts_256.mat';
net=load(model_path);
net=net.net; 

T=10; %%% same as time step in training 
n_LSTM_units=net.Layers(2).NumHiddenUnits;
data_input_weights=net.Layers(2).InputWeights;
h_weights=net.Layers(2).RecurrentWeights;
gate_bias=net.Layers(2).Bias; 
%%% MLP params %%%
weight1=net.Layers(3).Weights;
bias1=net.Layers(3).Bias; 
weight2=net.Layers(5).Weights;
bias2=net.Layers(5).Bias; 


% model_specs=struct(); 
% %%% LSTM params %%%
% model_specs.n_LSTM_units=n_LSTM_units; 
% model_specs.T=T; 
% model_specs.data_input_weights=data_input_weights;
% model_specs.h_weights=h_weights;
% model_specs.gate_bias=gate_bias;
% %%% MLP params %%%
% model_specs.weight1=weight1;
% model_specs.bias1=bias1;
% model_specs.weight2=weight2;
% model_specs.bias2=bias2;
% save('model_specs.mat','model_specs')
save('../model_specs/LSTM/n_LSTM_units.mat','n_LSTM_units')
save('../model_specs/LSTM/T.mat','T')
save('../model_specs/LSTM/data_input_weights.mat','data_input_weights')
save('../model_specs/LSTM/h_weights.mat','h_weights')
save('../model_specs/LSTM/gate_bias.mat','gate_bias')
save('../model_specs/MLP/weight1.mat','weight1')
save('../model_specs/MLP/bias1.mat','bias1')
save('../model_specs/MLP/weight2.mat','weight2')
save('../model_specs/MLP/bias2.mat','bias2')








