function [AG_FOVbinned] = AG_FOVbinned(Name, SummerizeDay,Z,distLimit)
%recieves a cell array. each 5 col have data of one day: Xpos Ypos Xneg Yneg space
%row 1 is strings, row 2 is for all cells
%analyze from row 3

%returns a new cell array

% %% definitions
% 
% Z=50;
% distLimit=300;
%% initialize the output cell array
[row, col]=size(SummerizeDay);
AG_FOVbinned=cell(row, (col+1)/5*2); %so will have 2 col per day. for pos and neg
%% populate the new cell array
target_col=1;
for days=1:5:col %this goes through the source data in steps of 5
    AG_FOVbinned{1,target_col}=SummerizeDay{1,days};%tittle
    for FOV=2:row
        if  sum(~isnan(SummerizeDay{FOV,days}))>0 % unless empty           
            %then send to AG_BinCorr(Name, X, Y, Z, limit)
            
            %pos corr 
            X=SummerizeDay{FOV,days};
            Y=SummerizeDay{FOV,days+1};
            AG_FOVbinned{FOV, target_col}=AG_BinCorr(Name, X,Y,Z,distLimit);%sending 
            %X and Y of that FOV , the bin size (Z), distlimit is the max distance 
            %returning a summary: name, mean sd, n
            
            %neg correlations. 
            X=SummerizeDay{FOV, days+2};
            Y=SummerizeDay{FOV, days+3};
            AG_FOVbinned{FOV, target_col+1}=AG_BinCorr(Name,X,Y,Z,distLimit); 
        end
    end%going through FOVs
    target_col=target_col+2;
end
            
            
