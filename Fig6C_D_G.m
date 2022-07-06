
load Uzel_WT.mat; %loading WT whole-brain imaging datasets
WT_Dataset=Uzel_WT;

%below is to designate which HisCl line will be used for the rest of the
%panels
load AVAAVERIMPVC_His.mat; % load HisCl dataset for any inhibition line
InhibitionDataset=AVAAVERIMPVC_His;
HisClType='AVAAVERIMPVC'; %make sure to correctly annotate the dataset here.


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

%% WT vs HisCl RMS cumulative curve (Panels C-right, D-right or G)

xcentres = (0:0.03:1.3); %For binning and x axis of histograms.
Analysis = @rms; %rms will be calculated as a measure of neuronal activity

WTNumDataSets=size(WT_Dataset,2); %finding the number of datasets in WT datasets
HISNumDataSets=size(InhibitionDataset,2); %finding the number of datasets in inhibition datasets

%% calculating RMS value of all recorded neurons in WT datasets 
%(except the inhibited ones in the designated inhibition datasets, those
%are excluded from the consecutive analyses

for i = 1:WTNumDataSets 
  
    clear range1
    range1=[1:size(WT_Dataset(i).traces,1)];
    clear DatasetNeuronIDs
    DatasetNeuronIDs=WT_Dataset(i).IDs;
    
    ExcludedNeurons=[];
    for j=1:length(exclude);
        for f=1:length(DatasetNeuronIDs);
            if strcmp(DatasetNeuronIDs{f}, exclude{j});
                ExcludedNeurons(j)=f;
            end
        end
    end
    clear f j
    ExcludedNeurons(ExcludedNeurons==0)=[];
    clear IncludedNeurons
    [~,NeuronN] =size(WT_Dataset(i).traces);
    IncludedNeurons = 1:NeuronN;
    IncludedNeurons(:,ExcludedNeurons) = [];
    clear NeuronN;
    
    clear Traces
        Traces =WT_Dataset(i).traces((range1),IncludedNeurons);

    clear RangeAnalysed
    RangeAnalysed = Analysis(Traces);

    WTBinnedRangeAnalysed(i,:) =(histc(RangeAnalysed,xcentres))/length(RangeAnalysed);

end
%% calculating RMS value of all recorded neurons in inhibition datasets 
%(except the inhibited ones in the designated inhibition datasets, those
%are excluded from the consecutive analyses

for i = 1:HISNumDataSets 
    
    clear range1
    range1=[1:size(InhibitionDataset(i).traces,1)];
    clear DatasetNeuronIDs
    DatasetNeuronIDs=InhibitionDataset(i).IDs;
    
    ExcludedNeurons=[];
    for j=1:length(exclude);
        for f=1:length(DatasetNeuronIDs);
            if strcmp(DatasetNeuronIDs{f}, exclude{j});
                ExcludedNeurons(j)=f;
            end
        end
    end
    clear f j
    ExcludedNeurons(ExcludedNeurons==0)=[];
    clear IncludedNeurons
    [~,NeuronN] =size(InhibitionDataset(i).traces);
    IncludedNeurons = 1:NeuronN;
    IncludedNeurons(:,ExcludedNeurons) = [];
    clear NeuronN;
    
    clear Traces

        Traces =InhibitionDataset(i).traces((range1),IncludedNeurons);

    
    clear RangeAnalysed
    RangeAnalysed = Analysis(Traces);
    
    HISBinnedRangeAnalysed(i,:) =(histc(RangeAnalysed,xcentres))/length(RangeAnalysed);


end
%% calculating cumulative sum of RMS values in WT and inhibition datasets

cumsum1= cumsum(mean(WTBinnedRangeAnalysed));
cumsum1_ind=cumsum((WTBinnedRangeAnalysed),2);
cumsum1_std=std(cumsum1_ind,1);

cumsum2= cumsum(mean(HISBinnedRangeAnalysed));
cumsum2_ind=cumsum((HISBinnedRangeAnalysed),2);
cumsum2_std=std(cumsum2_ind,1);

%color code
grey = [0.4,0.4,0.4];
lightblue = [0.5  0.5  1];
peach = [1 0.5 0.5];

%plotting
figure (1);
     hFig = figure(1);
     hold on
jbfill(xcentres,cumsum1+cumsum1_std,cumsum1-cumsum1_std,lightblue,lightblue,0,0.3);
jbfill(xcentres,cumsum2+cumsum2_std,cumsum2-cumsum2_std,peach,peach,0,0.3);
plot(xcentres,cumsum2,'Color','r','linewidth',3)
plot(xcentres,cumsum1,'Color','b','linewidth',3)

set(gca,'box','off')
xlabel('RMS')

ylabel('Fraction of Neurons')
ylim([0 1.05]);
xlim([0 1.2]);
set(gca,'TickDir', 'out')
set(gca,'fontsize',14)

title(strcat(HisClType,'-Inhibition vs WT'))
legend('WT','Inhibition')




