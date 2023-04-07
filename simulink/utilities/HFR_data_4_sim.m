%%% create data %%%
clc
clear all

%%% settings %%%
data_set_path='../../data/test_data.mat';
set_num=4;
%%% the following settings need to be the same as in the training 
time_step=10; 
feature_size=12;
skip=19;
%%% ends %%%        

data_all=load(data_set_path);
data=data_all.test_data.Data_Summary(set_num).data;

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
Cnb_valve=table2array(data(:,{'CombinationValveSetting'}));
Cnb_valve_fb=table2array(data(:,{'CombinedValveFeedback'}));
T_water_i=table2array(data(:,{'InletTemperatureFeedbackOfCoolingWater'}));
T_water_o=table2array(data(:,{'OnletTemperatureFeedbackOfCoolingWater'}));
valve=table2array(data(:,{'StatusOfHydrogenDischargeValve'}));
T_w_diff=T_water_o-T_water_i;
P_w_diff=P_water_o-P_water_i;
T_a_diff=T_air_o-T_air_i;
P_H2_diff=P_H2_o-P_H2_i;
%%% preprocess ends %%%%
data_HFR=zeros(length(V),12); %% init data_HFR

data_HFR=[V,I,air_flow,T_w_diff,T_water_i,P_water_i,P_w_diff,T_a_diff,T_air_i,P_H2_diff,P_H2_i,T_H2_o,HFR];
data_HFR=data_HFR([1:skip+1:end],:);  %%% skip every "skip" data points 
features=data_HFR(:,1:end-1); %%% extract features
SIZE=size(features);
data_num=SIZE(1);
to_save=[zeros(1,feature_size);features];
to_save=[0:data_num;to_save'];
data=double(to_save(:,1:end-3)); %%% -3 due to last three pts are NaN
save('../data/HFR_data_4_sim.mat','data','-v7.3');
HFR=data_HFR(10:end-3,end);
save('../data/HFR_ground_truth.mat','HFR','-v7.3');
