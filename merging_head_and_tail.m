%%
% saving simplestructs of Head and Tail individually.

%go to the folder of your head dataset. Quant folder must be there with
%wbstruct.mat in it.
temp=wbMakeSimpleStruct; %taking head dataset first
headdataset=temp.simple;
clear temp
%now switch to the folder of your tail dataset. Quant folder must be there with
%wbstruct.mat in it.
temp=wbMakeSimpleStruct;
taildataset=temp.simple;
clear temp
%%

ConcatStruct.traces=horzcat(headdataset.deltaFOverF_bc,taildataset.deltaFOverF_bc);

derivAlpha=0.0001;
derivIter=10;
ConcatStruct.derivatives=derivReg(ConcatStruct.traces,derivIter,derivAlpha);


ConcatStruct.IDs=horzcat(headdataset.ID,taildataset.ID);
ConcatStruct.tv=headdataset.tv;
ConcatStruct.fps=headdataset.fps;
ConcatStruct.dataset=headdataset.trialname;
ConcatStruct.options.derivAlpha=derivAlpha;
ConcatStruct.options.derivIter=derivIter;

%save ('ConcatStruct.mat','ConcatStruct') %optional, saving this
%concatanated version in the mail folder maybe?
%%
%load your structure file
%e.g. load Uzel_WT.mat;


%MainStruct=Uzel_WT;

DatasetNumber=5; %this it the dataset number where it will be added

MainStruct(DatasetNumber).traces=ConcatStruct.traces;
MainStruct(DatasetNumber).derivatives=ConcatStruct.derivatives;
MainStruct(DatasetNumber).IDs=ConcatStruct.IDs;
MainStruct(DatasetNumber).tv=ConcatStruct.tv;
MainStruct(DatasetNumber).fps=ConcatStruct.fps;
MainStruct(DatasetNumber).dataset=ConcatStruct.dataset;
MainStruct(DatasetNumber).options=ConcatStruct.options;

%rename and save the MainStruct.mat;
%this is now compatible with CorrelationHeatmaps2022.m