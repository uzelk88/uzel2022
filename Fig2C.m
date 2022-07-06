
%loading the connectome / network map
load Neuro279_EJ.mat; %matrix containing gap junctions
load Neuro279_Syn.mat; %matrix containing chemical synapses
load Order279.mat; %array containing the neuron order of matrices above

load Uzel_WT.mat; %loading WT whole-brain imaging datasets

%generating Correlation Matrix of the connectome averaged across all WT
%Datasets.
[AvgCorrMatr, ~, ~]= CorrelationHeatmaps2022(Uzel_WT,'derivs','Correlation',0,Order279);


%calculating all possible neuronal pairs within the connectome
comb_pairs=nchoosek(1:size(Neuro279_EJ,1),2); 

%calculating the absolute correlation coefficients of all possible neuronal pairs within the connectome
clear Values
for i=1:size(comb_pairs,1)
Values(i,1)=abs(AvgCorrMatr(comb_pairs(i,1),comb_pairs(i,2)));
end

%calculating sum of connections in weighted network
[sumofconnections_w]=calculateSoC(Neuro279_Syn,Neuro279_EJ,comb_pairs);

%% plotting Figure 2C

calculate_corrSp(sumofconnections_w,'Sum of Connections (weighted)',Values,'Pairwise Correlation (abs)',1)
  
