function [ResponsiveCells] = AG_CalculateReponsiveCells(SpontCellArray, StimCellArray)
fprintf('I assume we have spont threshold for each stim day. \n');
%[SpontCellArray,path2sourceDir] = uigetfile('*.mat','Select the SPONT CELL ARRAY file');

[SpontFOVs,SpontImagingDays]=size(SpontCellArray); 
[StimFovs,StimImagingDays]=size(StimCellArray);
if StimImagingDays>1
    for StimDay=1:StimImagingDays
        for SpontDay=1:SpontImagingDays
            if strcmp (SpontCellArray{1,SpontDay}, StimCellArray{1,StimDay})
                ResponsiveCells{1,StimDay}=StimCellArray{1,StimDay};
                threshold=prctile(SpontCellArray{2,SpontDay} ,95);
                nonMT_FOV=2;%1 is titles. this is for the target cell array
                %I got the threshold from the spont and now I'll use only
                %the stim 
                for iFOV=2:StimFovs %2 b/e the first row has a non FOV info
                    if length (StimCellArray{iFOV,StimDay})%if the cell isn't empty
                       ResponsiveCells{nonMT_FOV,StimDay} = StimCellArray{iFOV,StimDay} > threshold;
                       %this places 0 and 1 in 'ResponsiveCells_Hypo' for
                       %values that are above or not above threshold

                       %to calculate percent responsive for that FOV
                       %a{i,j}=sum a{i,j}/length a{i,j} *100
                       ResponsiveCells{nonMT_FOV,StimDay} = sum( ResponsiveCells{nonMT_FOV,StimDay} )/length(ResponsiveCells{nonMT_FOV,StimDay})*100;
                       nonMT_FOV=nonMT_FOV+1;
                    end
                end                    
                SpontDay=SpontImagingDays;%no need to continue the loop after finding a match   
            end %there was a day match between spont and stim cell arrays
        end    %of looping over spont days
    end%of looping over stim days of hypo
end%of if to see if there're values summerize Stim
