
% A stand alone  that was replaced by a function

%% 1. find the 95% percentile of spont for each day
%and for each condition
fprintf('I assume we have spont threshold for each stim day /n');
load('spont_Hyper.mat');
load('spont_Hypo.mat')
%these are 2 rows cell arrays
%% spont_Hypo
%loop over the days and find the 95% in each
[m,n]=size(SummerizeDay_spont_Hypo);% n is the number of imaging days 
for iDay=1:n
    percentiles_spont_Hypo{1,iDay}=strcat(SummerizeDay_spont_Hypo{1,iDay},'_spont_Hypo');
    percentiles_spont_Hypo{2,iDay} = prctile( SummerizeDay_spont_Hypo{2,iDay} ,95);
end
%% spont_Hyper
[m,n]=size(SummerizeDay_spont_Hyper);
for iDay=1:n
    percentiles_spont_Hyper{1,iDay}=strcat(SummerizeDay_spont_Hyper{1,iDay},'_spont_Hyper');
    percentiles_spont_Hyper{2,iDay} = prctile( SummerizeDay_spont_Hyper{2,iDay} ,95);
end
%% 2. find how many cells were above the 95% on each day and condition

% 2.1 for Hypo
load('stim_Hypo.mat');%the variable is called SummerizeDay_stim_Hypo"in the workspace
[m,n]=size(SummerizeDay_stim_Hypo);
[x,Z]=size(SummerizeDay_spont_Hypo);
if n>0
    for iDay=1:n
        %CellValues= SummerizeDay_stim_Hypo{2,iDay};
        %I assume we have spont threshold for this day
        %find the threshold for that day
        for SpontDay=1:Z
            if strcmp (SummerizeDay_stim_Hypo{1,iDay}, SummerizeDay_spont_Hypo{1,SpontDay})
                threshold=percentiles_spont_Hypo{2,SpontDay};
                CellValues=SummerizeDay_stim_Hypo{2,iDay} > threshold;
                ResponsiveCells_Hypo{1,iDay}=SummerizeDay_stim_Hypo{1,iDay};
                ResponsiveCells_Hypo{2,iDay}=sum(CellValues)/length(CellValues)*100;
                SpontDay=Z;%no need to continue the loof after finding a match
                %calculation for each fov
                nonMT_FOV=3;
                for iFOV=3:FOV %3 b/e the first 2 rows have a non FOV info
                    if length (SummerizeDay_stim_Hypo{iFOV,iDay})%if the cell isn't empty
                       ResponsiveCells_Hypo{nonMT_FOV,iDay} = SummerizeDay_stim_Hypo{iFOV,iDay} > threshold;
                       %this places 0 and 1 in 'ResponsiveCells_Hypo' for
                       %values that are above or not above threshold

                       %to calculate percent responsive for that FOV
                       ResponsiveCells_Hypo{nonMT_FOV,iDay} = sum( ResponsiveCells_Hypo{nonMT_FOV,iDay} )/length(ResponsiveCells_Hypo{nonMT_FOV,iDay})*100;
                       nonMT_FOV=nonMT_FOV+1;
                    end
                end                      
            end 
        end    %of looping over hypo spont days
    end%of looping over stim days of hypo
end%of if to see if there're values summerize Stim

% 2.2 for Hyper
load('stim_Hyper.mat');%the variable is called SummerizeDay_stim_Hypo" in the workspace
[m,n]=size(SummerizeDay_stim_Hyper);
[x,Z]=size(SummerizeDay_spont_Hyper);
if n>0
    for iDay=1:n
        for SpontDay=1:Z
            if strcmp (SummerizeDay_stim_Hyper{1,iDay}, SummerizeDay_spont_Hyper{1,SpontDay})
                threshold=percentiles_spont_Hyper{2,SpontDay};
                CellValues=SummerizeDay_stim_Hyper{2,iDay} > threshold;
                ResponsiveCells_Hyper{1,iDay}=SummerizeDay_stim_Hyper{1,iDay};
                ResponsiveCells_Hyper{2,iDay}=sum(CellValues)/length(CellValues)*100;
                SpontDay=Z;%no need to continue the loof after finding a match
                
                %calculation for each fov
                nonMT_FOV=3;
                for iFOV=3:FOV %3 b/e the first 2 rows have a non FOV info
                    if length (SummerizeDay_stim_Hyper{iFOV,iDay})%if the cell isn't empty
                       ResponsiveCells_Hyper{nonMT_FOV,iDay} = SummerizeDay_stim_Hyper{iFOV,iDay} > threshold;
                       %this places 0 and 1 in 'ResponsiveCells_Hypo' for
                       %values that are above or not above threshold

                       %to calculate percent responsive for that FOV
                       ResponsiveCells_Hyper{nonMT_FOV,iDay} = sum( ResponsiveCells_Hyper{nonMT_FOV,iDay} )/length(ResponsiveCells_Hyper{nonMT_FOV,iDay})*100;
                       nonMT_FOV=nonMT_FOV+1;
                    end
                end %going over FOVs             
            end % found a match day between the spont and stim
        end  %of looping over hyper spont days
    end%of looping over stim days of hyper
end%of if to see if there're values summerize Stim


%% per FOV

