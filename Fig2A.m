
%loading the connectome / network map
load Neuro279_EJ.mat; %matrix containing gap junctions
load Neuro279_Syn.mat; %matrix containing chemical synapses
load Order279.mat; %array containing the neuron order of matrices above

load Uzel_WT.mat; %loading WT whole-brain imaging datasets

%generating Correlation Matrix of the connectome averaged across all WT
%Datasets.
[AvgCorrMatr, ~, ~]= CorrelationHeatmaps2022(Uzel_WT,'derivs','Correlation',0,Order279);

%%
%loading all identified neuron pairs classified according to dyad motif
%pairs, 6 cells represent 6 groups in Figure S1F
load DyadMotifPairs.mat;

%column1 is pairs with only gap junctions
Column1_NeuronPairs=DyadMotifPairs{2};
clear Column1_CorrValues
for i=1:size(Column1_NeuronPairs,1)
Column1_CorrValues(i,1)=AvgCorrMatr(Column1_NeuronPairs(i,1),Column1_NeuronPairs(i,2));
end

%column2 is pairs with only unidirectional chemical synapses
Column2_NeuronPairs=DyadMotifPairs{3};
clear Column2_CorrValues
for i=1:size(Column2_NeuronPairs,1)
Column2_CorrValues(i,1)=AvgCorrMatr(Column2_NeuronPairs(i,1),Column2_NeuronPairs(i,2));
end

%column3 is non-connected neuron pairs
Column3_NeuronPairs=DyadMotifPairs{1};
clear Column3_CorrValues
for i=1:size(Column3_NeuronPairs,1)
Column3_CorrValues(i,1)=AvgCorrMatr(Column3_NeuronPairs(i,1),Column3_NeuronPairs(i,2));
end

%% plotting Figure 2A as boxplot

%concatenating 3 columns
%padconcatenation.m is from Andres Mauricio Gonzalez refer to the script
%for more details
figboxplot=padconcatenation(abs(Column1_CorrValues),abs(Column2_CorrValues),2);
figboxplot=padconcatenation(figboxplot,abs(Column3_CorrValues),2);

%plotting boxplot
boxplot(figboxplot,'Whisker',100);hold on

ylim([0 1])
xlim([0.5 size(figboxplot,2)+0.5])
set(gca,'XTickLabel',{'Only gap junctions','Only unidirectional chemical synapses','Non connected'})
title('Dyad Motifs')