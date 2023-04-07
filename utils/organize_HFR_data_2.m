main_path='..\data\excel_data\'; %%% data path 
dataset=1:30;

for i= 1:length(dataset)    
    fileName=[num2str(dataset(i)),'.xlsx'];
    filePath=[main_path,fileName];
    data=readtable(filePath);
    name{i}=num2str(dataset(i));
    value{i}=data;
end 
Data_Summary=struct('name',name,'data',value);
save('../data/DataSummary.mat','Data_Summary')