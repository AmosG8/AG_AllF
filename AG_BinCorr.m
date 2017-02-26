function [bin_Y_matrix]=AG_BinCorr(Name,X,Y,Z,distLimit)
    
% receives 2 related vectors X and Y 
% make bins in X in size Z until distLimit
% calculate the mean, SD, n of the data in Y for each bin
% returns a cell array
%Name=strcat(Name,'_');
LeftBinIndex=0;
bin_Y_matrix=cell(4,distLimit/Z);%initialize the cell array
bin_Y_matrix{1,1}=Name;
bin_Y_matrix{2,1}='mean';
bin_Y_matrix{3,1}='SD';
bin_Y_matrix{4,1}='n';

BinCounter=2;%that's the columns
%% 
while LeftBinIndex<distLimit 
   %a title for the current column
   Left_number=num2str(LeftBinIndex);
   Right_number=num2str(LeftBinIndex+Z);
   bin_Y_matrix{1,BinCounter}=strcat(Left_number,'-',Right_number);%coloumn tittle
  
   %find the indexes of the relvant data according X values
   indexes=find (X>(LeftBinIndex) & X<(LeftBinIndex+Z));
   %calulate on Y and populate the cell array
   bin_Y_matrix{2,BinCounter}=mean(Y(indexes));
   bin_Y_matrix{3,BinCounter}=std(Y(indexes));
   bin_Y_matrix{4,BinCounter}=length(indexes);
   
   BinCounter=BinCounter+1;
   LeftBinIndex=LeftBinIndex+Z;
end
   
   