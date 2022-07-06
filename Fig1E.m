
load Uzel_WT.mat; %loading WT whole-brain imaging datasets
load NeuronOrder.mat; % loading the list of identified neurons in WT datasets

%generating Correlation Matrix of all identified neurons averaged across all WT
%Datasets.
[AvgCorrMatr, CorrMatrOrder, ~]= CorrelationHeatmaps2022(Uzel_WT,'derivs','Correlation',0,NeuronOrder);

%% plotting Figure 1E Matrix

figure;
heatmap(AvgCorrMatr, CorrMatrOrder, CorrMatrOrder, [], 'NaNColor', [0 0 0], 'TickAngle', 90, 'ShowAllTicks', true, 'TickFontSize', 6,'MinColorValue',-1,'MaxColorValue',1)
axis image
colorbar
set(gca,'TickDir', 'out');

%note: I used the color code Red and Blue (Divergent) in Figure 1E taken from
% functions by Charles Robert see cbrewer.m for more information
% colors=colormap(cbrewer('div', 'RdBu', 64));


%% Hierarchical Clustering and Dendrogram
% the clustering was done by single linkage algorithm using matlabs linkage
% function. This script uses already sorted neuron order. Refer to CorrelationHeatmaps2022.m for more details



