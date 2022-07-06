
load NeuronOrder.mat; % loading the list of identified neurons in WT datasets
load Uzel_WT.mat; %loading WT whole-brain imaging datasets

%generating WTStruct to extract traces of identified neurons from all WT
%Datasets.
[~, ~, WTStruct]= CorrelationHeatmaps2022(Uzel_WT,'traces','Correlation',0,NeuronOrder);



for i=1:6 %for loop goes through 6 WT datasets
Name=strcat('InputTraces',num2str(i)); %InputTraces contain DF/F0 traces of identified neurons
RMSvalues(1,1:length(NeuronOrder),i)=rms(WTStruct.(Name),1); %calculating RMS to quantify neuronal activity levels
end

RMSvalues_AVG=nanmean(RMSvalues,3); %calculating the average RMS value of all identified neurons 


%loading the connectome / network map
load Neuro279_EJ.mat; %matrix containing gap junctions
load Neuro279_Syn.mat; %matrix containing chemical synapses
load Order279.mat; %array containing the neuron order of matrices above

%calculating total in-degree of neurons within the combined network
%(chemical synapses + gap junctions) of the connectome
[Total_Indegree_connectome,~,~]=degrees_dir(Neuro279_Syn+Neuro279_EJ);
%degrees_dir.m is from Brain Connectivity Toolbox (Rubinov, 2010), please
%refer to Key Resources Table for full citation.


%calculating the numbers where the identified neurons in NeuronOrder.mat
%corresponds within the connectome
clear NeuronOrder_numbered
  for i=1:length(Order279);
        for j=1:length(NeuronOrder);
            if strcmp(NeuronOrder(j), Order279{i});
               NeuronOrder_numbered(j)=i;
            end
        end
  end

%total in degree of identified neurons in WT datasets
Total_In_Degrees=Total_Indegree_connectome(NeuronOrder_numbered);
  
  
 %% plotting Figure 1D
 
 %calculating Spearman's rank coefficient between in-degrees in combined
 %network vs. neuronal activity levels (RMS)
 calculate_corrSp(Total_In_Degrees','In degree (chemical synapses + gap junctions)',RMSvalues_AVG','RMS (average)',1)

  
  

