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
comb_pairs=nchoosek(1:size(Neuro279_EJ,1),2);

%loading matrices of functional connectivity
load Matrices_FC.mat;
% this is the order of the matrices (matches y-axis of Figure 4 functional measures):
% Matrices_FC{1}=Correlation Coefficient (input: time-derivatives)
% Matrices_FC{2}=Correlation Coefficient (input:traces)
% Matrices_FC{3}=Covariance (input: time-derivatives)
% Matrices_FC{4}=Covariance (input:traces)
% Matrices_FC{5}=Peak Cross Correlation (input: time-derivatives)
% Matrices_FC{6}=Peak Cross Correlation (input:traces)
% Matrices_FC{7}=Mutual Information (input: time-derivatives)
% Matrices_FC{8}=Mutual Information (input:traces)
% Matrices_FC{9}=Covariogram Analysis

%calculating direct connectivity
[sumofconnections_t]=calculateSoC(c_t,g_t,comb_pairs); %on unweighted network
[sumofconnections_w]=calculateSoC(c,g,comb_pairs); %on weighted network
%calculating sum of inverse shortest paths 
[inverseLambda_intact]=calculateLinv_lite6(c,g,comb_pairs);
%calculating primary input similarities
prim_w_cos=calculatePIP(cg,comb_pairs,'cos'); %on weighted network - cosine similarity
prim_t_cos=calculatePIP(cg_t,comb_pairs,'cos'); %on unweighted network - cosine similarity
prim_t_dot=calculatePIP(cg_t,comb_pairs,'dot'); %on unweighted network, dot product = total count of common inputs
%calculating secondary input similarities
secon_w_cos=calculateSIP_w(cg,comb_pairs,'cos'); %on weighted network - cosine similarity
secon_t_cos=calculateSIP_t(cg_t,comb_pairs,'cos'); %on unweighted network - cosine similarity
secon_t_dot=calculateSIP_t(cg_t,comb_pairs,'dot'); %on unweighted network, dot product = total count of common inputs
%the order above matches x-axis of Figure 4 (anatomical measures)

%calculating a Table of Spearman's rank coefficient between pairs of functional and anatomical measures
clear Table
for k=1:size(Matrices_FC,2);
    InputMatr=Matrices_FC{k};
%
clear Values
for i=1:size(comb_pairs,1)
Values(i,1)=abs(InputMatr(comb_pairs(i,1),comb_pairs(i,2)));
end
[Table(k,1)]=calculate_corrSp(sumofconnections_t,'Sum of Connections (Adjacency)',Values,'PairwiseCorrelation',0);
[Table(k,2)]=calculate_corrSp(sumofconnections_w,'Sum of Connections (Weighted)',Values,'PairwiseCorrelation',0);
[Table(k,3)]=calculate_corrSp(inverseLambda_intact,'1 / shortest path',Values,'PairwiseCorrelation',0);
[Table(k,4)]=calculate_corrSp(prim_w_cos,'Primary Input Similarity (Adjacency-Cos)',Values,'PairwiseCorrelation',0);
[Table(k,5)]=calculate_corrSp(prim_t_cos,'Primary Input Similarity (Adjacency-Dot)',Values,'PairwiseCorrelation',0);
[Table(k,6)]=calculate_corrSp(prim_t_dot,'Primary Input Similarity (Weighted-Dot)',Values,'PairwiseCorrelation',0);
[Table(k,7)]=calculate_corrSp(secon_w_cos,'Secondary Input Similarity (Adjacency-Cos)',Values,'PairwiseCorrelation',0);
[Table(k,8)]=calculate_corrSp(secon_t_cos,'Secondary Input Similarity (Adjacency-Dot)',Values,'PairwiseCorrelation',0);
[Table(k,9)]=calculate_corrSp(secon_t_dot,'Secondary Input Similarity (Weighted-Dot)',Values,'PairwiseCorrelation',0);

end

%%  Plotting Figure 4

%generate a colormap from cbrewer functions by Charles Robert see cbrewer.m for more information
colors=cbrewer('seq', 'Greens', 32); 

%labels for axes
conorder={'Correlation Coefficient (dDF / dt)','Correlation Coefficient (DF)','Covariance (dDF / dt)','Covariance (DF)','Peak Cross Correlation (dDF / dt)','Peak Cross Correlation (DF)','Mutual Information (dDF / dt)','Mutual Information (DF)','Covariogram Analysis'};
anatorder={'Direct Connectivity (unweighted)','Direct Connectivity (weighted)','Sum of inverse shortest path','1 input similarity (cos sim. weighted)','1 input similarity (cos sim. unweighted)','1 input similarity (total # of common inputs)','2 input similarity (cos sim. weighted)','2 input similarity (cos sim. unweighted)','2 input similarity (total # of common inputs)'};
%
figure;
colormap(colors)
heatmap(Table, anatorder, conorder, [], 'NaNColor', [0 0 0], 'TickAngle', 45, 'ShowAllTicks', true, 'TickFontSize', 6,'MinColorValue',0,'MaxColorValue',0.6)
colorbar

set(gca,'TickDir', 'out')
box off
set(gca,'FontSize',14)

%writing rs values for each pair of measures
for i=1:9
    for j=1:9
text(i-0.27,j,strcat('rs = ',{' '},num2str(round(Table(j,i),2))),'FontSize',15)
    end
end


