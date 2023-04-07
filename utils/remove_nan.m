clc
clear all 

train_file='../data/train_data.mat';
train_set=load(train_file);
train_set=train_set.train_data;
train_data=removeNan(train_set);
save(train_file,'train_data')

test_file='../data/test_data.mat';
test_set=load(test_file);
test_set=test_set.test_data;
test_data=removeNan(test_set);
save(test_file,'test_data')

function out_data=removeNan(data_set)
%%% remove last row if NaN is found in last row
    n_loop=length(data_set.Data_Summary);
    for iter=1:n_loop
        data=data_set.Data_Summary(iter).data;
        %% delete NaN in data %%
        if sum(ismissing(data_set.Data_Summary(iter).data(end,:)))~=0
            data_set.Data_Summary(iter).data=data_set.Data_Summary(iter).data(1:end-1,:);
        end 
    end 
    out_data=data_set; 
end 
 