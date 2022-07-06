%choosing the anatomical measure here
%options are:
%'primary' for primary input similarity; Figure 7F middle
%'secondary' for secondary input similarity; Figure 7F right
%'invlambda' for sum of inverse shortest path; Figure 7F left
Measure='primary';

%loading the connectome / network map
load Neuro279_EJ.mat; %matrix containing gap junctions
load Neuro279_Syn.mat; %matrix containing chemical synapses
load Order279.mat; %array containing the neuron order of matrices above

c=Neuro279_Syn; %chemical synapse network
g=Neuro279_EJ;   %gap junction network
cg=c+g;             %combined network
cg_t=double(cg>0); %combined network - unweighted
c_t=double(c>0);    %chemical synapse network - unweighted
g_t=double(g>0);    %gap junction network - unweighted

%calculating all possible neuronal pairs within the connectome
comb_pairs=nchoosek(1:size(Neuro279_EJ,1),2);%

load Uzel_WT.mat; %loading WT whole-brain imaging datasets
%loading multiple hub neuron inhibition datasets
load AVAAVERIMPVC_His.mat;
load AVBRIBAIB_His.mat;

%%
%generating Correlation Matrix of the connectome averaged across all WT
%Datasets.
[AvgCorrMatr, ~, ~]= CorrelationHeatmaps2022(Uzel_WT,'derivs','Correlation',0,Order279);

%calculating the absolute correlation coefficients of all  neuronal pairs
clear Values
for i=1:size(comb_pairs,1)
    Values(i,1)=abs(AvgCorrMatr(comb_pairs(i,1),comb_pairs(i,2)));
end
%

%calculating secondary input similarity (cosine similarity) for all pairs in unweighted network
[secon_intact]=calculateSIP_t(cg_t,comb_pairs,'cos');
%calculating primary input similarity (cosine similarity) for all pairs in unweighted network
[prim_intact]=calculatePIP(cg_t,comb_pairs,'cos');
%calculating sum of inverse shortest paths for all pairs in unweighted network
[inverseLambda_intact]=calculateLinv_lite6(c_t,g_t,comb_pairs);

Conditions={'AVAAVERIMPVC','AVBRIBAIB'}; %conditions represent all multiple hub neuron inhibition lines

for kkk=1:length(Conditions);
    Condition=Conditions{kkk};
    
    clear Neuronstobezeroed Input_InhibitionDataset
    
    %below is to exclude the inhibited neurons from the analysis.
    switch Condition
        case 'AVAAVERIMPVC'
            Neuronstobezeroed={'AVAL','AVAR','AVEL','AVER','PVCL','PVCR','RIML','RIMR'};
            Input_InhibitionDataset=AVAAVERIMPVC_His;
            
        case 'AVBRIBAIB'
            
            Neuronstobezeroed={'AVBL','AVBR','RIBL','RIBR','AIBL','AIBR'};
            Input_InhibitionDataset=AVBRIBAIB_His;
    end
    
    clear Neuronstobezeroed_num
    for i=1:length(Order279);
        for j=1:length(Neuronstobezeroed);
            if strcmp(Neuronstobezeroed(j), Order279{i});
                Neuronstobezeroed_num(j)=i;
            end
        end
    end
    
    %generating Correlation Matrix of the connectome averaged across all
    %designated inhibition datasets
    [temp_extended_corr_matr, ~, ~]= CorrelationHeatmaps2022(Input_InhibitionDataset,'derivs','Correlation',0,Order279);
    
    %generating perturbed networks with the removal of specified neurons
    temp_cg=perturb_matrix(cg,Order279,Neuronstobezeroed);
    temp_c=perturb_matrix(c,Order279,Neuronstobezeroed);
    temp_g=perturb_matrix(g,Order279,Neuronstobezeroed);
    
    %below is to exclude the inhibited neurons from the analysis.
    temp_extended_corr_matr(:,Neuronstobezeroed_num)=nan;
    temp_extended_corr_matr(Neuronstobezeroed_num,:)=nan;
    
    %rename the WT average correlation matrix
    temp_extended_corr_matr_correspondingWT=AvgCorrMatr;
    
    %below is to exclude the inhibited neurons from the analysis (WT values this time).    
    temp_extended_corr_matr_correspondingWT(:,Neuronstobezeroed_num)=nan;
    temp_extended_corr_matr_correspondingWT(Neuronstobezeroed_num,:)=nan;
    
    
    %calculating the absolute correlation coefficients of all neuronal
    %pairs in inhibition and WT datasets
    clear  tempHisValues tempWTValues
    for i=1:size(comb_pairs,1)
        tempHisValues(i,1)=abs(temp_extended_corr_matr(comb_pairs(i,1),comb_pairs(i,2)));
        tempWTValues(i,1)=abs(temp_extended_corr_matr_correspondingWT(comb_pairs(i,1),comb_pairs(i,2)));
    end
    
    %calculating the selected measure for all pairs
    if strcmp(Measure,'secondary')
        [temp_second]=calculateSIP_t(temp_cg,comb_pairs,'cos');
    elseif strcmp(Measure,'primary')
        [temp_prim]=calculatePIP(temp_cg,comb_pairs,'cos');
        
    elseif strcmp(Measure,'invlambda')
        [temp_Linv]=calculateLinv(temp_c,temp_g,comb_pairs,6);
        
    end
    
    %calculating the percent change in the selected measure due to in
    %silico perturbation of the network
    clear temp_PercentChange
    for i=1:size(comb_pairs,1)
        
        if strcmp(Measure,'secondary')
            temp_PercentChange(i)=abs(secon_intact(i)-temp_second(i))/secon_intact(i);
        elseif strcmp(Measure,'primary')
            temp_PercentChange(i)=abs(prim_intact(i)-temp_prim(i))/prim_intact(i);
        elseif strcmp(Measure,'invlambda')
            temp_PercentChange(i)=abs(inverseLambda_intact(i)-temp_Linv(i))/inverseLambda_intact(i);
            
        end
        
        
        NeuronPairs(i,1:2)=[comb_pairs(i,1),comb_pairs(i,2)];
        
    end
    
    %saving the results from multiple network hub inhibition lines
    %within the for loop
    if strcmp(Measure,'secondary')
        CCV{kkk}=[tempWTValues,tempHisValues,secon_intact,temp_second,temp_PercentChange',NeuronPairs];
    elseif strcmp(Measure,'primary')
        CCV{kkk}=[tempWTValues,tempHisValues,prim_intact,temp_prim,temp_PercentChange',NeuronPairs];
    elseif strcmp(Measure,'invlambda')
        CCV{kkk}=[tempWTValues,tempHisValues,inverseLambda_intact,temp_Linv,temp_PercentChange',NeuronPairs];
        
    end
    
end


%concatenating the results from multiple network hub inhibition lines
MultiHubResults=[];
for i=1:numel(CCV);
    MultiHubResults=[MultiHubResults;CCV{i}];
end

%filtering out the neuron pairs that were not recorded within both datasets
Filtered_Results=MultiHubResults(find(~isnan(MultiHubResults(:,1)) | ~isnan(MultiHubResults(:,2))),:);

PercentChange=Filtered_Results(:,5); %percent changes in the selected measure of the recorded neuronal pairs
PooledWTCorVal=Filtered_Results(:,1); %WT correlation values of the recorded neuronal pairs
PooledDataCorVal=Filtered_Results(:,2); %Inhibition correlation values of the recorded neuronal pairs

%% plotting the histogram for both perturbed and unaffected pairs (according
%to percent change)
figure;
subplot(2,1,1)
thresh1=0.1; %threshold for the classification of perturbed and unaffected pairs
histogram(abs(PooledWTCorVal(find(PercentChange>=thresh1))),0:0.025:1,'Normalization','Probability','FaceAlpha',0.5);
hold on;
histogram(abs(PooledDataCorVal(find(PercentChange>=thresh1))),0:0.025:1,'Normalization','Probability','FaceAlpha',0.5);
ylim([0 0.18])
xlabel('Absolute Correlation Coefficient')
ylabel('Fraction')
set(gca,'FontSize',14)
title('Perturbed Pairs (>10%)')
%
subplot(2,1,2)
histogram(abs(PooledWTCorVal(find(PercentChange<thresh1))),0:0.025:1,'Normalization','Probability','FaceAlpha',0.5);
hold on;
histogram(abs(PooledDataCorVal(find(PercentChange<thresh1))),0:0.025:1,'Normalization','Probability','FaceAlpha',0.5);

ylim([0 0.18])
xlabel('Absolute Correlation Coefficient')
ylabel('Fraction')
set(gca,'FontSize',14)
title('Unaffected Pairs (<10%)')




