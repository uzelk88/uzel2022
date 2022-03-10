%load a dataset structure

load Uzel_WT.mat;

%load neuron order for the matrices

load NeuronOrder66.mat;


[AvgCorrMatr, CorrMatrOrder, OutputStruct]= CorrelationHeatmaps2022(Uzel_WT,'derivs','Correlation',0,NeuronOrder66);

%%
figure;
heatmap(AvgCorrMatr, CorrMatrOrder, CorrMatrOrder, [], 'NaNColor', [0 0 0], 'TickAngle', 45, 'ShowAllTicks', true, 'TickFontSize', 6,'MinColorValue',-1,'MaxColorValue',1)
axis image
colorbar
