close all;
clear all;
clc;

load ../data/DataSummary.mat;



for i = 1:1:length(Data_Summary)
%  for i = 1:1:1
   
    dataTemp = Data_Summary(i).data;
    
    figure;
    hold on;
    box on;   
    
    yyaxis left
    plotTemp = plot(dataTemp{:, 32});    
    set(plotTemp, 'LineWidth', 1.5);    
    axis([1, length(dataTemp{:, 32}), 100, 140])    
    ylabel('HFR [Ohm]');
    xlabel('Time');
    set(gca, 'YColor', 'black', 'LineWidth', 1.5);
    
    yyaxis right
    plotTemp = plot(dataTemp{:, 14});
    set(plotTemp, 'LineWidth', 1.5);
    ylabel('Total current [A]');
    xlabel('Time');
    
    title(['HFR and total current vs. time, dataset: ',num2str(i)]);    
    set(gca, 'YColor', 'black', 'LineWidth', 1.5, 'FontSize', 12);
    set(gcf, 'Unit', 'Inches', 'position',[1,1,8,4]);
    
    
    saveas(gcf, ['../Data/DataSummary_Plot/DataSet_', num2str(i), '.png']);
end

