
%loading the connectome / network map
load Neuro279_EJ.mat; %matrix containing gap junctions
load Neuro279_Syn.mat; %matrix containing chemical synapses
load Order279.mat; %array containing the neuron order of matrices above

%generating Correlation Matrix of the connectome averaged across all WT
%Datasets.
[AvgCorrMatr, ~, ~]= CorrelationHeatmaps2022(Uzel_WT,'derivs','Correlation',0,Order279);

%% plotting Figure 2B

AvgCorrMatr(AvgCorrMatr==1)=nan; %taking 1's (auto-correlations) out
edges=-1:0.05:1; %defining histogram bins

figure; 
histogram(AvgCorrMatr,edges,'Normalization','Probability') %histogram of all pairs


GJpairs=AvgCorrMatr(Neuro279_EJ>0); %finding neuron pairs with gap junctions

hold on
histogram(GJpairs,edges,'Normalization','Probability') %histogram of pairs with gap junctions

xlabel('Correlation Coefficient')
ylabel('Probability')
legend('All pairs','GJ pairs')
set(gca,'FontSize',14)
