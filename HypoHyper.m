function [EP_Condition]=HypoHyper(EP_Type,condition)
%this function receives a structure in which there are
%Hyper or Hypo rows.
%it will return a structure with only those experiments of
%condition = HYPO or HYPER as defined by condition
EP_Condition = struct('animalID',[],'conditionID',[],'dataFileName',[],...
    'daysAfterBaseline',[],'experimentType',[],'FOV',[],'fps',[],...
    'maxProjImg',[],'Coor',[],'C_df',[],'S_or',[],'StimVector',[],'SpeedVector',[],...
    'run_stim',[],'run_no_stim',[],'stand_stim',[],'stand_no_stim',[],...
    'C_df_run_stim',[],'C_df_run_no_stim',[],'C_df_stand_stim',[],'C_df_stand_no_stim',[]);
%%
Condition_counter=1;
for iEXs=1:numel(EP_Type)
    if strcmp(EP_Type(iEXs).conditionID, condition)
       EP_Condition(Condition_counter)=EP_Type(iEXs);
       Condition_counter=Condition_counter+1;
    end
end
%result=EP_Condition;