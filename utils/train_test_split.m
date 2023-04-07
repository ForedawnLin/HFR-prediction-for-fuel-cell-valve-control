clc
clear all
%%%% get all data %%%%
filePath='../data/DataSummary.mat'; 
all_data=load(filePath); 

%%% split train and test from train test folder(use image to decide train and test data) %%%
train_folder='..\data\DataSummary_Plot\train';
train_data=data_set_from_folder(train_folder,all_data); 
save('../data/train_data.mat','train_data')

test_folder='..\data\DataSummary_Plot\test';
test_data=data_set_from_folder(test_folder,all_data); 
save('../data/test_data.mat','test_data')




function data_set=data_set_from_folder(folder_path,total_data)
files=dir(folder_path); 
set_num=[]; 
for i=3:length(files)
    fileName=files(i).name;
    strs=split(fileName,{'_','.'});
    set_num=[set_num str2num(strs{2})];
end 
 
data_set=struct();
for i=1:length(set_num)
    data_set.Data_Summary(i)=total_data.Data_Summary(set_num(i));
end 

end 