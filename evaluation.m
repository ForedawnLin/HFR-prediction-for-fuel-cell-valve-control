clear all
%%%%% Extract useful data %%%%%
train_file='../software/data/train_data.mat';
train_set=load(train_file);
train_set=train_set.train_data;
 
test_file='../software/data/test_data.mat';
test_set=load(test_file);
test_set=test_set.test_data;

skip=19;
time_step=10;
[train_feature,train_Y,train_feature_array,train_Y_array]= create_LSTM_cell(train_set,time_step,0,1,skip);
[test_feature,test_Y,test_feature_array,test_Y_array]= create_LSTM_cell(test_set,time_step,0,0,skip);
 

%%% parse files in folder so that files are sorted according to training order %%%
folder_path='model/model_1';
file_list=dir(folder_path);
file_names={file_list.name};
file_names(1)=[];
file_names(1)=[];
file_num=[]; 
for i=1:length(file_names)
    name=file_names{i};
    str_splits=split(name,'__');
    file_num=[file_num str2num(str_splits{2})];
end 
[sort_result,out_index]=sort(file_num); 
model_files=file_names(out_index);



rMSE_train=[]; 
rMSE_test=[];
%%% plot training rmse and test %%%
for n=1:length(model_files)
    model=[folder_path '/' model_files{n}];
    net=load(model);
    net=net.net;
    %%%% check train dataset %%%%%
    YPred_train=predict(net,train_feature);
    YPred_final_train=[];
    gt_final_train=[]; 
    for i=1:length(YPred_train) 
        YPred_final_train=[YPred_final_train YPred_train{i}(end)];
        gt_final_train=[gt_final_train train_Y{i}(end)];
    end 
    rMSE_train=[rMSE_train sqrt(sum((YPred_final_train- gt_final_train).^2)/length(YPred_final_train))];       
    
    
    
    %%% check test dataset %%%%
    YPred=predict(net,test_feature);
    YPred_final=[];
    gt_final=[]; 
    for i=1:length(YPred) 
        YPred_final=[YPred_final YPred{i}(end)];
        gt_final=[gt_final test_Y{i}(end)];
    end 

    rMSE_test=[rMSE_test sqrt(sum((YPred_final-gt_final).^2)/length(YPred))];       
    n
end 
 
save([folder_path 'rMSE_train.mat'],'rMSE_train')
save([folder_path 'rMSE_test.mat'],'rMSE_test')
plot(rMSE_train);hold on;plot(rMSE_test);ylabel("RMSE");xlabel("Epochs");legend("train","test");
title("Training error and test error")



