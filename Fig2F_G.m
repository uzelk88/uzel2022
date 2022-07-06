
%loading the connectome / network map
load Neuro279_EJ.mat; %matrix containing gap junctions
load Neuro279_Syn.mat; %matrix containing chemical synapses
load Order279.mat; %array containing the neuron order of matrices above

load LRpairs.mat; %loading L-R pairs within the connectome (Neuron names correspond to Order279.mat)

%calculating all possible neuronal pairs within the connectome
comb_pairs=nchoosek(1:size(Neuro279_EJ,1),2);

%generating Correlation Matrix of the connectome averaged across all WT
%Datasets.
[AvgCorrMatr, ~, ~]= CorrelationHeatmaps2022(Uzel_WT,'derivs','Correlation',0,Order279);

%finding non L-R pairs (will be named RemainingPairs)
count=1;
for i=1:size(comb_pairs,1);
    clear temprow
    temprow=comb_pairs(i,:);
    clear test
    for j=1:size(LRpairs,1);
        test(j)=isequal(LRpairs(j,:),temprow);
    end
    
    if ~sum(test)>0;
        Remaining_pairs(count,1:2)=temprow;
        count=count+1;
    end
    
end
%
%calculating the correlation coefficients of all  L-R pairs
clear Values_LR
for i=1:size(LRpairs,1)
Values_LR(i,1)=(AvgCorrMatr(LRpairs(i,1),LRpairs(i,2)));
end
%calculating the correlation coefficients of all non L-R pairs
clear Values_remaining
for i=1:size(Remaining_pairs,1)
Values_remaining(i,1)=(AvgCorrMatr(Remaining_pairs(i,1),Remaining_pairs(i,2)));
end

%% plotting Figure 2G
Values_remaining(isnan(Values_remaining))=[];
Values_LR(isnan(Values_LR))=[];


figure;
histogram(Values_remaining,[-1:0.05:1],'Normalization','Probability') %non L-R pairs
hold on
histogram(Values_LR,[-1:0.05:1],'Normalization','Probability') %L-R pairs
box off
ylabel('Fraction')
xlabel('Correlation Coefficient')
legend('non L-R pairs','L-R pairs')
set(gca,'FontSize',14)

%% plotting Figure 2F

figure;
%padconcatenation.m is from Andres Mauricio Gonzalez refer to the script
%for more details
figboxplot=padconcatenation(abs(Values_remaining),abs(Values_LR),2);

boxplot(figboxplot,'Whisker',100);hold on

ylim([0 1])
xlim([0.5 size(figboxplot,2)+0.5])
set(gca,'XTickLabel',{'Non L-R Pairs','L-R Pairs'})
