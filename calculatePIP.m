%this function calculates the primary input similarity of the input
%neuronal pair(s).

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
%       output: primary input similarity of the input neuronal pairs
%
%
%example usage:
%prim_w_cos=calculatePIP(cg,comb_pairs,'cos'); %from Fig4.m
%where cg is combined network, comb_pairs is all pairs within the network,
%and 'cos' is for cosine similarity

function [output]=calculatePIP(inputmatrix,input_pairs,Method)
cg=inputmatrix;

Primaryinput_Results=zeros(size(input_pairs,1),1);
for i=1:size(input_pairs,1)
    
    %below is to calculate similarity between input vectors according to
    %the specified method
    
    if strcmp(Method,'dot')
        Primaryinput_Results(i,1)=dot(cg(:,input_pairs(i,1)),cg(:,input_pairs(i,2)));
    elseif strcmp(Method,'cos')
        Primaryinput_Results(i,1)=vecdifsimple(cg(:,input_pairs(i,1)),cg(:,input_pairs(i,2)));
    end
    
end
output=Primaryinput_Results;
end
