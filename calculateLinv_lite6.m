
%this function calculates sum of inverse shortest path between input
%neuronal pair(s).
%note: distance_bin.m from Brain Connectivity Toolbox (BCT) is used. Please
%refer to key resources table in Uzel et al. 2022 for full citation.

function [output]=calculateLinv_lite6(input_cg,comb_pairs)
CG=distance_bin(input_cg);

for i=1:size(comb_pairs,1)
  
       Lambdaresults(i,1)=(1/CG(comb_pairs(i,1),comb_pairs(i,2)))+(1/CG(comb_pairs(i,2),comb_pairs(i,1)));

    output=Lambdaresults;
end