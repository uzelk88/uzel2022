%calculating sum of connections between input neuron pair(s).

function [output]=calculateSoC(inputmatrix_c,inputmatrix_g,input_pairs)
SumofCoonnection_Results=zeros(size(input_pairs,1),1);

for i=1:size(input_pairs,1)
    
 SumofCoonnection_Results(i,1)=inputmatrix_c(input_pairs(i,2),input_pairs(i,1))+inputmatrix_c(input_pairs(i,1),input_pairs(i,2))+inputmatrix_g(input_pairs(i,1),input_pairs(i,2));

end
output=SumofCoonnection_Results;
end
