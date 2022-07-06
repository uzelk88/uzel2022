
%this function calculates secondary input similarity of the input
%neuronal pair(s), works only with thresholded (unweighted) matrices

% Inputs:
%
%       inputmatrix, : this is the input network map (usually the
%       connectome for the Uzel et al. 2022 scripts)
%
%       input_pairs, : this is the neuron pairs between which the input
%       similarity will be calculated (usually all possible pairs within
%       the network for the Uzel et al. 2022 scripts)
%
%       Method,   : 'dot', 'cos' for dot product or cosine similarity
%
% Outputs:
%
%       output: secondary input similarity of the input neuronal pairs
%
%
%example usage:
%secon_t_cos=calculateSIP_t(cg_t,comb_pairs,'cos'); %from Fig4.m
%where cg is combined network, comb_pairs is all pairs within the network,
%and 'cos' is for cosine similarity

function [output]=calculateSIP_t(inputmatrix,input_pairs,Method)
cg=inputmatrix;

Secondaryinput_Results=zeros(size(input_pairs,1),1);
for i=1:size(input_pairs,1)
    cn5t1=cg(:,input_pairs(i,1));
    cn5t2=cg(:,input_pairs(i,2));
    secondary_inputs_1=zeros(size(cg,1),1);
    secondary_inputs_2=zeros(size(cg,1),1);
    
    if sum(cn5t1)>0
        set1_1=find(cn5t1);
        [set2_1_pre,~] =find(cg(:,set1_1));
        secondary_inputs_1(set2_1_pre)=1;
    end
    
    if sum(cn5t2)>0
        set1_2=find(cn5t2);
        [set2_2_pre,~] =find(cg(:,set1_2));
        secondary_inputs_2(set2_2_pre)=1;
    end
    
    if strcmp(Method,'dot')
        
    Secondaryinput_Results(i,1)=dot(secondary_inputs_1,secondary_inputs_2);
    elseif strcmp(Method,'cos')
 Secondaryinput_Results(i,1)=vecdifsimple(secondary_inputs_1,secondary_inputs_2);
    end
    
end
output=Secondaryinput_Results;
end