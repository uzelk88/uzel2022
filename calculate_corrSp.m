%[output]=calculate_corrSp(values1,v1label,values2,v2label,plotting)

% Inputs:
%
%       values1     : Array containing the values to be plotted in x-axis must
%       be in vertical form (n x 1)
%
%       v1label     : Label of x-axis in case plotting is on
%
%       values2     : Array containing the values to be plotted in y-axis must
%       be in vertical form (n x 1)
%
%       vylabel     : Label of y-axis in case plotting is on
%    
%       plotting,    : 1 or 0, if 1 function produces a scatter plot
%       between two values, their Spearman's rank coefficient will be the
%       title
%
% Outputs:
%
%       output: Spearman's rank coefficient between two input values


%example usage from Fig1D.m:
%calculate_corrSp(Total_In_Degrees','In degree (c+g)',RMSvalues_AVG','RMS (average)',1)




function [output]=calculate_corrSp(values1,v1label,values2,v2label,plotting)

v1=values1;
v2=values2;

% NaNs removal
v2(isnan(v1))=[];
v1(isnan(v1))=[];
%
v1(isnan(v2))=[];
v2(isnan(v2))=[];

% Zeros removal
% correlation calculation
corrc=corr(double(v1),double(v2),'Type','Spearman');
%corrc=corr(double(v1),double(v2),'Type','Pearson');

if plotting==1;
   % figure;
plot(v1,v2,'o','MarkerSize',5)

title(strcat('r: ',num2str(round(corrc,3))));
box off

xlabel(v1label)
%     xlabel('Primary input similarity (dot product)')
ylabel(v2label)
set(gca,'FontSize',14)
end

output=corrc;
end
