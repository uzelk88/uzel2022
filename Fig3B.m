
%loading the connectome / network map
load Neuro279_EJ.mat; %matrix containing gap junctions
load Neuro279_Syn.mat; %matrix containing chemical synapses
load Order279.mat; %array containing the neuron order of matrices above

load LRpairs.mat; %loading L-R pairs within the connectome (Neuron names correspond to Order279.mat)

%calculating all possible neuronal pairs within the connectome
comb_pairs=nchoosek(1:size(Neuro279_EJ,1),2);

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

%generating the combined network
cg=Neuro279_Syn+Neuro279_EJ; 
cg_t=double(cg>0); %combined network - unweighted

%calculating primary input similarity (cosine similarity) for L-R pairs
prim_LR=calculatePIP(cg_t,LRpairs,'cos');

%calculating primary input similarity (cosine similarity) for all remaining pairs (non L-R pairs)
prim_Remaining=calculatePIP(cg_t,Remaining_pairs,'cos');

%% plotting Figure 3B

figure;
histogram(prim_Remaining,[0:0.05:1],'Normalization','Probability') %primary input similarity of all remaining pairs
hold on
histogram(prim_LR,[0:0.05:1],'Normalization','Probability') %primary input similarity of L-R pairs
box off
ylabel('Fraction')
xlabel('Primary Input Similarity')
set(gca,'FontSize',18)
set(gca,'TickDir', 'out');
legend('All pairs','L-R pairs')
