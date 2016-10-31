function [EP_Condition]=HypoHyper(EP_Type,condition)
%this function receives a structure in which there are
%Hyper or Hypo rows.
%it will return a structure with only those experiments of
%condition = HYPO or HYPER as defined by condition
EP_Condition = struct('animalID',[],'conditionID',[],'dataFileName',[],...
    'daysAfterBaseline',[],'experimentType',[],'FOV',[],'fps',[],...
    'maxProjImg',[],'Coor',[],'C_df',[],'S_or',[],'StimVector',[],'SpeedVector',[]);
%%
Condition_counter=1;
for iEXs=1:numel(EP_Type)
    if strcmp(EP_Type(iEXs).conditionID, condition)
       EP_Condition(Condition_counter)=EP_Type(iEXs);
       Condition_counter=Condition_counter+1;
    end
end
%result=EP_Condition;