%loading the connectome / network map
load Neuro279_EJ.mat; %matrix containing gap junctions
load Neuro279_Syn.mat; %matrix containing chemical synapses
load Order279.mat; %array containing the neuron order of matrices above

load Uzel_WT.mat; %loading WT whole-brain imaging datasets

%generating Correlation Matrix of the connectome averaged across all WT
%Datasets.
[AvgCorrMatr, ~, ~]= CorrelationHeatmaps2022(Uzel_WT,'derivs','Correlation',0,Order279);

%generating the combined network
cg=Neuro279_Syn+Neuro279_EJ; 
cg_t=double(cg>0); %combined network - unweighted

%calculating all possible neuronal pairs within the connectome
comb_pairs=nchoosek(1:size(Neuro279_EJ,1),2);


%calculating the absolute correlation coefficients of all  neuronal pairs
clear Values
for i=1:size(comb_pairs,1)
Values(i,1)=abs(AvgCorrMatr(comb_pairs(i,1),comb_pairs(i,2)));
end

%calculating secondary input similarity (cosine similarity) for all pairs in unweighted network
secondary_t_cos=calculateSIP_t(cg_t,comb_pairs,'cos');

%% plotting Figure 3F

calculate_corrSp(secondary_t_cos,'Secondary Input Similarity',Values,'Pairwise Correlation (abs)',1)



