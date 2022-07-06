%loading the connectome / network map
load Neuro279_EJ.mat; %matrix containing gap junctions
load Neuro279_Syn.mat; %matrix containing chemical synapses
load Order279.mat; %array containing the neuron order of matrices above

load Uzel_WT.mat; %loading WT whole-brain imaging datasets

load NeuronOrder.mat; % loading the list of identified neurons in WT datasets

%generating the combined network
cg=Neuro279_Syn+Neuro279_EJ; 
cg_t=double(cg>0); %combined network - unweighted

%calculating the numbers where the identified neurons in NeuronOrder.mat
%corresponds within the connectome (Order279.mat)
    for i=1:length(Order279);
        for j=1:length(NeuronOrder);
            if strcmp(NeuronOrder(j), Order279{i});
                NeuronOrder_numbered(j)=i;
            end
        end
    end

%generating primary and secondary input similarity matrices (dimensions 65 x 65)    
Prim_matrix=zeros(length(NeuronOrder_numbered),length(NeuronOrder_numbered));
Secon_matrix=zeros(length(NeuronOrder_numbered),length(NeuronOrder_numbered));

for i=1:length(NeuronOrder_numbered)
    for j=1:length(NeuronOrder_numbered)
        Prim_matrix(i,j)=calculatePIP(cg_t,[NeuronOrder_numbered(i) NeuronOrder_numbered(j)],'cos');
        Secon_matrix(i,j)=calculateSIP_t(cg_t,[NeuronOrder_numbered(i) NeuronOrder_numbered(j)],'cos');
    end
end

%nan'ing the main digaonals
for i=1:size(Prim_matrix,1);
Prim_matrix(i,i)=nan;
Secon_matrix(i,i)=nan;
end

%generating Correlation Matrix of all identified neurons average across all WT
%Datasets.
[AvgCorrMatr, ~, ~]= CorrelationHeatmaps2022(Uzel_WT,'derivs','Correlation',0,NeuronOrder);

%generating a reduced connection matrix (65 x 65)
Reducedconmatr=cg(NeuronOrder_numbered,NeuronOrder_numbered);
Reducedconmatr(Reducedconmatr==0)=nan;


%% plotting Figure 3G

figure;

subplot(2,2,1)
heatmap(Reducedconmatr, [], [], [], 'NaNColor', [0 0 0], 'TickAngle', 45, 'ShowAllTicks', true, 'TickFontSize', 8,'MinColorValue',0,'MaxColorValue',30)
axis image
colorbar
set(gca,'FontSize',14)
set(gca,'TickDir', 'out');
title('# of connections (weighted connectome)')

subplot(2,2,2)
heatmap(Prim_matrix, [], [], [], 'NaNColor', [0 0 0], 'TickAngle', 45, 'ShowAllTicks', true, 'TickFontSize', 8,'MinColorValue',-0,'MaxColorValue',1)
axis image
colorbar
set(gca,'FontSize',14)
set(gca,'TickDir', 'out');
title('1 Input similarity (unweighted connectome)')

subplot(2,2,3)
heatmap(Secon_matrix, [], [], [], 'NaNColor', [0 0 0], 'TickAngle', 45, 'ShowAllTicks', true, 'TickFontSize', 8,'MinColorValue',-0,'MaxColorValue',1)
axis image
colorbar
set(gca,'FontSize',14)
set(gca,'TickDir', 'out');
title('2 Input similarity (unweighted connectome)')

subplot(2,2,4)
heatmap(abs(AvgCorrMatr), [], [], [], 'NaNColor', [0 0 0], 'TickAngle', 45, 'ShowAllTicks', true, 'TickFontSize', 8,'MinColorValue',0,'MaxColorValue',1)
axis image
colorbar
set(gca,'FontSize',14)
set(gca,'TickDir', 'out');
title('Functional interaction map')




 

