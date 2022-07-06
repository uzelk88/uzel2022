%this function perturbs the network by zeroing the available connections in
%the neurons designated as the input

% Inputs:
%
%       InputMatrix, : the network to begin with (usually the connectome
%       279x279)
%
%       ReferenceOrder, : the neuron order that corresponds to the
%       InputMatrix. this will be used as a reference to find which neurons
%       to remove.
%
%       Neurontotakeout,   : list of the neurons to be taken out (zeroed)
%       from the InputMatrix
%
% Outputs:
%
%       OutputMatrix: perturbed network, similar in size with InputMatrix
%       with designated neurons (with Neurontotakeout) zeroed.

%example usage:
%  c_perturbed=perturb_matrix(c,Order279,NeuronstobeRemoved);
%or
%  c_perturbed=perturb_matrix(c,Order279,{'AVAL','AVAR'});


function OutputMatrix=perturb_matrix(InputMatrix,ReferenceOrder,Neurontotakeout)   

OutputMatrix=InputMatrix;
    
for i=1:length(ReferenceOrder);
    for j=1:length(Neurontotakeout);
        if strcmp(Neurontotakeout(j), ReferenceOrder{i});
            NeuronstobeRemoved_num(j)=i;
        end
    end
end

    
OutputMatrix(NeuronstobeRemoved_num,:)=0;
OutputMatrix(:,NeuronstobeRemoved_num)=0;    