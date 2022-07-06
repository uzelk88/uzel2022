

load Uzel_WT.mat; %loading WT whole-brain imaging datasets
load NeuronOrder.mat; % loading the list of identified neurons in WT datasets

%below is to designate which HisCl line will be used for the rest of the
%panels
load AVAAVERIMPVC_His.mat; % load HisCl dataset for any inhibition line
Input_InhibitionDataset=AVAAVERIMPVC_His;
HisClType='AVAAVERIMPVC'; %make sure to correctly annotate the dataset here.

ylimit=0.28; %setting the limit of y-axis for the histograms

%below is to exclude the inhibited neurons from the analysis.
%important note: the variable in line10 must match one of the options below
clear exclude
switch HisClType
    case 'AVAAVERIMPVC'
        exclude={'RIML','RIMR','PVCR','PVCL','AVAL','AVAR','AVEL','AVER'};
        
    case 'AVBRIBAIB'
        exclude={'AVBL','AVBR','RIBL','RIBR','AIBL','AIBR'};
        
    case 'AVA'
        exclude={'AVAL','AVAR'};
        
    case 'AVE'
        exclude={'AVEL','AVER'};
        
    case 'RIM'
        exclude={'RIML','RIMR'};
        
    case 'PVC'
        exclude={'PVCR','PVCL'};
        
    case 'AVB'
        exclude={'AVBL','AVBR'};
        
    case 'RIB'
        exclude={'RIBL','RIBR'};
        
    case 'AIB'
        exclude={'AIBL','AIBR'};
        
    case 'RIMPVC'
        exclude={'RIML','RIMR','PVCR','PVCL'};
        
end

edges=[-1:0.05:1]; % edges of the histogram

%inhibited neurons are excluded from the neuron order, thus, from the
%consecutive analyses
NeuronOrder=exclude_forcorrmatr(NeuronOrder,exclude);

%%
%generating WT and Inhibition average correlation matrices
[WT_Matrix, ~, ~]= CorrelationHeatmaps2022(Uzel_WT,'derivs','Correlation',0,NeuronOrder);
[HIS_Matrix, ~, ~]= CorrelationHeatmaps2022(Input_InhibitionDataset,'derivs','Correlation',0,NeuronOrder);



%% WT vs HisCl histogram (Panels C-left, D-left or F)

%taking 1's (auto-correlations) from the main diagonal out.
WT_Matrix=maindiag_nan(WT_Matrix);
HIS_Matrix=maindiag_nan(HIS_Matrix);

%plotting the histograms
figure;
h1=histogram(WT_Matrix,edges,'Normalization','probability');
hold on
h2=histogram(HIS_Matrix,edges,'Normalization','probability');
ylim([0 ylimit]);
xlabel('Correlation Coefficient')
ylabel('Fraction')
set(gca,'fontsize',15)





