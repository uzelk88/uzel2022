%% Setting the color code to Red and Blue (Divergent)
%note: I used the color code Red and Blue (Divergent) in Figure 1E taken from
% functions by Charles Robert see cbrewer.m for more information
% colors=colormap(cbrewer('div', 'RdBu', 64));

colors=colormap(cbrewer('div', 'RdBu', 64));
close all
colorsflip=flipud(colors);
set(0,'DefaultFigureColormap',colorsflip);
%% Plotting Fig1E Matrix

load Uzel_WT.mat; %loading WT whole-brain imaging datasets
load NeuronOrder.mat; % loading the list of identified neurons in WT datasets

%below is to designate which HisCl line will be used for the rest of the
%panels
load AVAAVERIMPVC_His.mat; % load HisCl dataset for any inhibition line
Input_InhibitionDataset=AVAAVERIMPVC_His; 
HisClType='AVAAVERIMPVC'; %make sure to correctly annotate the dataset here.


%generating the correlation matrix of all identified neurons averaged across all
%Inhibition datasets.
[Initial_AvgCorrMatr, Initial_CorrMatrOrder, ~]= CorrelationHeatmaps2022(Input_InhibitionDataset,'derivs','Correlation',0,NeuronOrder);

%finding which neurons were not identified in this set of inhibition datasets
Initial_CorrMatrOrder(find(isnan(diag(Initial_AvgCorrMatr))))=[];

%re-calculating the average correlation matrix with the updated neuron
%order (now only with identified ones within this set of inhibition datasets
[Final_AvgCorrMatr, Final_CorrMatrOrder, ~]= CorrelationHeatmaps2022(Input_InhibitionDataset,'derivs','Correlation',0,Initial_CorrMatrOrder);


%% plotting Average Correlation Matrix (Panels A, B or E)

figure;
heatmap(Final_AvgCorrMatr, Final_CorrMatrOrder, Final_CorrMatrOrder, [], 'NaNColor', [0 0 0], 'TickAngle', 90, 'ShowAllTicks', true, 'TickFontSize', 6,'MinColorValue',-1,'MaxColorValue',1)
axis image
colorbar
set(gca,'TickDir', 'out');
title(strcat(HisClType,'-Inhibition'),'FontSize',14)

