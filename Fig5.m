%loading the connectome / network map
load Neuro279_EJ.mat; %matrix containing gap junctions
load Neuro279_Syn.mat; %matrix containing chemical synapses
load Order279.mat; %array containing the neuron order of matrices above

%loading NeuronClasses, grouped by L-R pairs if it exists.
load NeuronClasses.mat;

%choosing the anatomical measure here
%options are:
%'primary' for primary input similarity; Figure 5A left
%'secondary' for secondary input similarity; Figure 5A middle
%'invlambda' for sum of inverse shortest path; Figure 5A right
Measure='primary';


%below is the list for rich club neurons according to Figure S4A in terms of
%numbers within NeuronClasses.mat
%AVA 61
%AVE 64
%AVD 63
%AVB 62
%PVC 60
%DVA 103
%AIB 37
%RIB 44
%RIA 43
%HSN 86
%RIH 98
%RIM 66
%AVJ 54
%AVK 55

RichClub_nums=[54,55,66,98,86,43,44,37,103,60,62,63,64,61];
AVAAVERIMPVC=[66,60,61,64];
AVBRIBAIB=[37,44,62];

c=Neuro279_Syn; %chemical synapse network
g=Neuro279_EJ;   %gap junction network
cg=c+g;             %combined network
cg_t=double(cg>0); %combined network - unweighted
c_t=double(c>0);    %chemical synapse network - unweighted
g_t=double(g>0);    %gap junction network - unweighted

%calculating all possible neuronal pairs within the connectome
comb_pairs=nchoosek(1:size(Neuro279_EJ,1),2);

%calculating the chosen anatomical measure for all neuron pairs and
%generating a WT reference value by calculating their mean
switch Measure
    case 'invlambda'
        [WT_values]=calculateLinv_lite6(c_t,g_t,comb_pairs);
        WT_ref_mean=nanmean(WT_values);
    case 'primary'
        [WT_values]=calculatePIP(cg_t,comb_pairs,'dot');
        WT_ref_mean=nanmean(WT_values);
    case 'secondary'
        [WT_values]=calculateSIP_t(cg_t,comb_pairs,'cos');
        WT_ref_mean=nanmean(WT_values);
end

%generating single removal perturbations (Figure 5A, 1st columns)
SingleRemovals=1:length(NeuronClasses);
%
clear SingleRemovalResults
for i=1:size(SingleRemovals,2);
    i
    clear NeuronstobeRemoved
    
    if i<93 %bypass so that single cell removals will work.
        NeuronstobeRemoved=NeuronClasses{(i)};
    else
        NeuronstobeRemoved=NeuronClasses(i);
    end
    
    clear c_perturbed g_perturbed cg_perturbed
    clear c_perturbed_t g_perturbed_t cg_perturbed_t
    %generating perturbed networks with the removal of specified neurons
    c_perturbed=perturb_matrix(c,Order279,NeuronstobeRemoved);
    g_perturbed=perturb_matrix(g,Order279,NeuronstobeRemoved);
    cg_perturbed=c_perturbed+g_perturbed;
    
    cg_perturbed_t=double(cg_perturbed>0);
    c_perturbed_t=double(c_perturbed>0);
    g_perturbed_t=double(g_perturbed>0);
    
    %calculating the selected measure for all pairs
    switch Measure
        case 'invlambda'
            clear tempSingleRemoval
            tempSingleRemoval=calculateLinv_lite6(c_perturbed_t,g_perturbed_t,comb_pairs);
            SingleRemovalResults(i,1)=nanmean(tempSingleRemoval);
            
        case 'primary'
            clear tempSingleRemoval
            tempSingleRemoval=calculatePIP(cg_perturbed_t,comb_pairs,'dot');
            SingleRemovalResults(i,1)=nanmean(tempSingleRemoval);
            
        case 'secondary'
            clear tempSingleRemoval
            tempSingleRemoval=calculateSIP_t(cg_perturbed_t,comb_pairs,'cos');
            SingleRemovalResults(i,1)=nanmean(tempSingleRemoval);
    end
    
end
%%
%calculating single network hub removals, Figure 5A Column2
SingleHUBRemovalResults=SingleRemovalResults(RichClub_nums);

% add other reference neuron calculations for inhibitions
Neurons_to_remove_for_reference={'AVAL','AVAR','AVEL','AVER','RIML','RIMR','PVCL','PVCR'};



clear c_perturbed g_perturbed cg_perturbed
clear c_perturbed_t g_perturbed_t cg_perturbed_t

c_perturbed=perturb_matrix(c,Order279,Neurons_to_remove_for_reference);
g_perturbed=perturb_matrix(g,Order279,Neurons_to_remove_for_reference);
cg_perturbed=c_perturbed+g_perturbed;

cg_perturbed_t=double(cg_perturbed>0);
c_perturbed_t=double(c_perturbed>0);
g_perturbed_t=double(g_perturbed>0);


switch Measure
    case 'invlambda'
        clear tempSingleRemoval
        tempReference_inhibition=calculateLinv_lite6(c_perturbed_t,g_perturbed_t,comb_pairs);
        reference_inhibition=nanmean(tempReference_inhibition);
        
    case 'primary'
        clear tempSingleRemoval
        tempReference_inhibition=calculatePIP(cg_perturbed_t,comb_pairs,'dot');
        reference_inhibition=nanmean(tempReference_inhibition);
        
    case 'secondary'
        clear tempSingleRemoval
        tempReference_inhibition=calculateSIP_t(cg_perturbed_t,comb_pairs,'cos');
        reference_inhibition=nanmean(tempReference_inhibition);
end

%% plotting Figure 5A

%concatenating 2 columns
dataconcat=padconcatenation(SingleRemovalResults,SingleHUBRemovalResults,2);
%padconcatenation.m is from Andres Mauricio Gonzalez refer to the script
%for more details

%plotting violin plots
hFig = figure;
set(gcf,'PaperPositionMode','auto')
set(hFig, 'Position', [500 500 500 1850])

%drawing intact connectome reference value
line([0 5],[WT_ref_mean WT_ref_mean],'LineStyle','--','Color',[63/256 63/256 63/256],'Color',[63/256,63/256,63/256,0.5])
%labeling intact connectome reference value
text(2.5,WT_ref_mean,'intact connectome')

%drawing designated perturbation reference value
line([0 5],[reference_inhibition reference_inhibition],'LineStyle','--','Color',[63/256 63/256 63/256],'Color',[63/256,63/256,63/256,0.5])
%labeling designated perturbation reference value
text(2.5,reference_inhibition,Neurons_to_remove_for_reference)



a1=violinplot(dataconcat,{'','','',''},'ShowData',false,'ShowNotches',false,'ShowMean',false,'MedianColor',[1 0 0],'BoxColor',[0.5 0.5 0.5]);
a1(1,2).ViolinPlot.LineWidth=1;
a1(1,2).ViolinPlot.EdgeColor=[229/256 92/256 101/256];
a1(1,2).ViolinPlot.FaceColor=[237/256 28/256 36/256];
a1(1,1).BoxColor=[0.5 0.5 0.5];
a1(1,1).WhiskerPlot.Visible='off';
a1(1,2).WhiskerPlot.Visible='off';

a1(1,1).MedianPlot.MarkerEdgeColor=[1 0 0];
a1(1,2).MedianPlot.MarkerEdgeColor=[1 0 0];


a1(1,1).ViolinPlot.LineWidth=1;
a1(1,1).ViolinPlot.EdgeColor=[63/256 63/256 63/256];
a1(1,1).ViolinPlot.FaceColor=[63/256 63/256 63/256];


set(gca,'FontSize',14)
set(gca,'TickDir', 'out');
xlim([0 3])





