function HFR = filterHFR(data,th)
% data: input data of size (m*1)
% get rid of spike
shape=size(data);
for i=1:shape(1)-1
    if data(i+1)-data(i)>=th 
        data(i+1)=data(i)+0.1;
    elseif data(i+1)-data(i)<=-th
        data(i+1)=data(i)-0.1;
    end 
    
end 
HFR=data;

end

