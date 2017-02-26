function [EP_type]=SpontStim(EP,condition)
%this function receives a structure EP in which all rows
%are either SPONT or STIM.
%it will return a structure with only those experiments of
%type = spont or stim as defined by condition
EP_type = struct('animalID',[],'conditionID',[],'dataFileName',[],...
    'daysAfterBaseline',[],'experimentType',[],'FOV',[],'fps',[],...
    'maxProjImg',[],'Coor',[],'C_df',[],'S_or',[],'StimVector',[],'SpeedVector',[],...
     'run_stim',[], 'run_no_stim',[], 'stand_stim',[], 'stand_no_stim',[],...
     'C_df_run_stim',[], 'C_df_run_no_stim',[], 'C_df_stand_stim',[], 'C_df_stand_no_stim',[]);
%%
Condition_counter=1;
%if numel(EP)>1%when empty it's 1
    for iEXs=1:numel(EP)
        if strcmp(EP(iEXs).experimentType, condition)
           EP_type(Condition_counter)=EP(iEXs);
           Condition_counter=Condition_counter+1;
        end
    end
%end