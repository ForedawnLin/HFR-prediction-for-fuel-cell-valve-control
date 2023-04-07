function [feature_seq,feature_Y,out_feature_array,out_Y_array] = create_LSTM_cell(data_sets,time_step,shuffle,filter,skip)
%%% dataset: array with dataset names 
%%% time_step: how long the LSTM sequence would b,e 
%%% shuffle: if shuffle the data cell; 1: is shuffle 
%%% filter: 1: use sgolay filter 0:don't use it   
%%% skip: how many data to skip 

%%% feature_seq and feature_Y: features to feed in LSTM-MLP model 
%%% out_feature_array and out_feature_Y: organized array n*m
 

%%% This version includes air_flow as an input variale

%%% init data interval 
LSTM_in={}; %%% n_sample_data cells, with input_dim*time_step for each cell 
LSTM_Y={}; 
feature_array=[];
Y_array=[];


%% all
data_set=data_sets;

n_loop=length(data_set.Data_Summary);

for iter=1:n_loop
    data=data_set.Data_Summary(iter).data;
    HFR=table2array(data(:,{'EIS_f5_Real_part'}));   
    time_stamp=table2array(data(:,{'TimeStamp'}));
    P_H2_o=table2array(data(:,{'HydrogenOutletPressure'}));
    P_H2_i=table2array(data(:,{'FeedbackOfHydrogenInletPressure'}));
    T_H2_o=table2array(data(:,{'HydrogenOutletTemperature'}));
    P_water_i=table2array(data(:,{'CoolingWaterInletPressure'}));
    P_water_o=table2array(data(:,{'CoolingWaterOutletPressure'}));
    T_air_i=table2array(data(:,{'AirInletTemperature'}));
    T_air_o=table2array(data(:,{'AirOutletTemperature'}));
    air_flow=table2array(data(:,{'TotalAirFlow'}));
    I=table2array(data(:,{'TotalCurrent'}));
    V=table2array(data(:,{'TotalVoltage'}));
%     Cnb_valve=table2array(data(:,{'CombinationValveSetting'}));
%     Cnb_valve_fb=table2array(data(:,{'CombinedValveFeedback'}));
    T_water_i=table2array(data(:,{'InletTemperatureFeedbackOfCoolingWater'}));
    T_water_o=table2array(data(:,{'OnletTemperatureFeedbackOfCoolingWater'}));
%     valve=table2array(data(:,{'StatusOfHydrogenDischargeValve'}));
    HFR=filterHFR(HFR,5);    %%% filter HFR of large values 
    %%%% data loading ends %%%%
    
    %%% preprocess some of the features %%%
    T_w_diff=T_water_o-T_water_i;
    P_w_diff=P_water_o-P_water_i;
    T_a_diff=T_air_o-T_air_i;
    P_H2_diff=P_H2_o-P_H2_i;
    %%% preprocess ends %%%%
    data_HFR=zeros(length(V),12); %% init data_HFR
    if filter==1
        order=1; %%% sgolay filter params 
        framelen=101; %%% sgolay filter params
        to_filter=[air_flow,T_w_diff,T_water_i,P_water_i,P_w_diff,T_a_diff,T_air_i,P_H2_diff,P_H2_i,T_H2_o,HFR];
        filtered=sgolayfilt(to_filter,order,framelen); %%% filter signals 
        data_HFR=[V,I,filtered];  %%%%% V and I are not filtered    
    else
        data_HFR=[V,I,air_flow,T_w_diff,T_water_i,P_water_i,P_w_diff,T_a_diff,T_air_i,P_H2_diff,P_H2_i,T_H2_o,HFR]; %%% didn't filter
    end 
    data_HFR=data_HFR([1:skip+1:end],:);  %%% skip every "skip" data points 
    features=data_HFR(:,1:end-1); %%% extract features 
    
    model_length=time_step;
    features1=features(model_length:end,:);
    feature_array=[feature_array;features1];
    
    Y=data_HFR(:,end); %%% extract ground truth (HFR data)
    Y1=Y(model_length:end);
    Y_array=[Y_array;Y1];

    
    SIZE=size(features); 
    n_sample=SIZE(1);

    %%%%%%%% arrange data for LSTM %%%%%%%%
    %%% arrange train data seq %%%% 
    for i=1:n_sample-time_step+1 
        LSTM_in{end+1}=features(i:i+time_step-1,:)';
    end 
    for i=1:n_sample-time_step+1 
        LSTM_Y{end+1}=Y(i:i+time_step-1)';
    end 
end 




%%% shuffle data or not %%%
if shuffle ==1 
    index_rnd=randperm(length(LSTM_Y));
    LSTM_in_rnd=LSTM_in(index_rnd);
    LSTM_Y_rnd=LSTM_Y(index_rnd);
    feature_seq=LSTM_in_rnd';
    feature_Y=LSTM_Y_rnd';
else
    feature_seq=LSTM_in';
    feature_Y=LSTM_Y';
end
%%% shuffle setting ends %%%
out_feature_array=feature_array; %%%%  (z*n)*m feature array, (z=# of dataset) (n=# of pts in a dataset)
out_Y_array=Y_array;%%%%  (z*n)*1 ground truth array, (z=# of dataset) (n=# of pts in a dataset)


end

