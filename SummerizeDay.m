%function [SummerizeDay_spont_Hyper, SummerizeDay_spont_Hypo, SummerizeDay_stim_Hyper, SummerizeDay_stim_Hypo]=SummerizeDay(EP_FILES_COMPILED)

%returns 4 cell arrays
%each of them has 2 rows: the 1st row contains strings with the days
%the 2nd contains a vector of S_or summerized for each day
%normalized for 100msec (Artificial_fps=10)
clear all;
load('EP_FILES_COMPILED.mat');
%% Definitions
Artificial_fps=10; %normalize S_or to 10fps
Default_fps=4.36; %for case the fps isn't provided in the structure
Imaging_Days=[];
EP_stim = struct('animalID',[],'conditionID',[],'dataFileName',[],...
    'daysAfterBaseline',[],'experimentType',[],'FOV',[],'fps',[],...
    'maxProjImg',[],'Coor',[],'C_df',[],'S_or',[],'StimVector',[],'SpeedVector',[],...
    'run_stim',[],'run_no_stim',[],'stand_stim',[],'stand_no_stim',[] );
EP_spont = struct('animalID',[],'conditionID',[],'dataFileName',[],...
    'daysAfterBaseline',[],'experimentType',[],'FOV',[],'fps',[],...
    'maxProjImg',[],'Coor',[],'C_df',[],'S_or',[],'StimVector',[],'SpeedVector',[],...
    'run_stim',[],'run_no_stim',[],'stand_stim',[],'stand_no_stim',[]);

%% 1. make new structs out of 'EP_FILES_COMPILED' named 'EP_spont' and 'EP_stim' 
%that contains only spont or stim

%1.1 make EP_spont
Spont_counter=1;
for iEX=1:numel(EP_FILES_COMPILED)%AGG
    if strcmp(EP_FILES_COMPILED(iEX).experimentType, 'SPONT')
       EP_spont(Spont_counter) = EP_FILES_COMPILED(iEX);
       Spont_counter=Spont_counter+1;
    end
end

%1.2 make EP_stim
Stim_counter=1;
for iEX=1:numel(EP_FILES_COMPILED)
    if strcmp(EP_FILES_COMPILED(iEX).experimentType, 'STIM')
       EP_stim(Stim_counter) = EP_FILES_COMPILED(iEX);
       Stim_counter=Stim_counter+1;
    end
end
%% 2. separate EP_spont and EP_stim each to Hypo and Hyper 
%so I get 4 structures in total
HyperStruct_spont=HypoHyper(EP_spont,'HYPER-TAC');
HypoStruct_spont=HypoHyper(EP_spont,'HYPO-TAC');

HyperStruct_stim=HypoHyper(EP_stim,'HYPER-TAC');
HypoStruct_stim=HypoHyper(EP_stim,'HYPO-TAC');

%% 3. find the days in which there was imaging and place them in a vector
%Imaging_Days is [ 'DAY_0' 'DAY_1'  'DAY_14' 'DAY_28' 'DAY_4'  'DAY_7' ]
Imaging_DaysHyper_spont = unique(extractfield(HyperStruct_spont, 'daysAfterBaseline'));
Imaging_DaysHypo_spont = unique(extractfield(HypoStruct_spont, 'daysAfterBaseline'));

Imaging_DaysHyper_stim = unique(extractfield(HyperStruct_stim, 'daysAfterBaseline'));
Imaging_DaysHypo_stim = unique(extractfield(HypoStruct_stim, 'daysAfterBaseline'));
%Imaging_Days is [ 'DAY_0' 'DAY_1'  'DAY_14' 'DAY_28' 'DAY_4'  'DAY_7' ]
%c = char(AG_days_of_imaging_spont)
%c(1,:)=day0
%c(1,5:end) ->the number

%% 4. Correct S_or and make cell arrays that contain same day data out of the structures done in section 2 
spont_Hyper = AG_summerizeDAY_general_F (Imaging_DaysHyper_spont,HyperStruct_spont, 'S_or');
spont_Hypo = AG_summerizeDAY_general_F (Imaging_DaysHypo_spont,HypoStruct_spont, 'S_or');
stim_Hyper = AG_summerizeDAY_general_F (Imaging_DaysHyper_stim,HyperStruct_stim, 'S_or');
stim_Hypo = AG_summerizeDAY_general_F (Imaging_DaysHypo_stim,HypoStruct_stim, 'S_or');

stand_no_stimulation_spont_Hyper = AG_summerizeDAY_general_F (Imaging_DaysHyper_spont,HyperStruct_spont, 'stand_no_stim');
stand_no_stimulation_spont_Hypo = AG_summerizeDAY_general_F (Imaging_DaysHypo_spont,HypoStruct_spont, 'stand_no_stim');
stand_no_stimulation_stim_Hyper = AG_summerizeDAY_general_F (Imaging_DaysHyper_stim,HyperStruct_stim, 'stand_no_stim');
stand_no_stimulation_stim_Hypo = AG_summerizeDAY_general_F (Imaging_DaysHypo_stim,HypoStruct_stim, 'stand_no_stim');

stand_stimulation_spont_Hyper = AG_summerizeDAY_general_F (Imaging_DaysHyper_spont,HyperStruct_spont, 'stand_stim');
stand_stimulation_spont_Hypo = AG_summerizeDAY_general_F (Imaging_DaysHypo_spont,HypoStruct_spont, 'stand_stim');
stand_stimulation_stim_Hyper = AG_summerizeDAY_general_F (Imaging_DaysHyper_stim,HyperStruct_stim, 'stand_stim');
stand_stimulation_stim_Hypo = AG_summerizeDAY_general_F (Imaging_DaysHypo_stim,HypoStruct_stim, 'stand_stim');

run_stimulation_spont_Hyper = AG_summerizeDAY_general_F (Imaging_DaysHyper_spont,HyperStruct_spont, 'run_stim');
run_stimulation_spont_Hypo = AG_summerizeDAY_general_F (Imaging_DaysHypo_spont,HypoStruct_spont, 'run_stim');
run_stimulation_stim_Hyper = AG_summerizeDAY_general_F (Imaging_DaysHyper_stim,HyperStruct_stim, 'run_stim');
run_stimulation_stim_Hypo = AG_summerizeDAY_general_F (Imaging_DaysHypo_stim,HypoStruct_stim, 'run_stim');

run_NOstimulation_spont_Hyper = AG_summerizeDAY_general_F (Imaging_DaysHyper_spont,HyperStruct_spont, 'run_no_stim');
run_NOstimulation_spont_Hypo = AG_summerizeDAY_general_F (Imaging_DaysHypo_spont,HypoStruct_spont, 'run_no_stim');
run_NOstimulation_stim_Hyper = AG_summerizeDAY_general_F (Imaging_DaysHyper_stim,HyperStruct_stim, 'run_no_stim');
run_NOstimulation_stim_Hypo = AG_summerizeDAY_general_F (Imaging_DaysHypo_stim,HypoStruct_stim, 'run_no_stim');

%% 5. save the summary variables   save(filename,variables)
save('stim_Hypo','stim_Hypo');
save('stim_Hyper','stim_Hyper');
save('spont_Hypo','spont_Hypo');
save('spont_Hyper','spont_Hyper');

save('stand_no_stimulation_stim_Hypo','stand_no_stimulation_stim_Hypo');
save('stand_no_stimulation_stim_Hyper','stand_no_stimulation_stim_Hyper');
save('stand_no_stimulation_spont_Hypo','stand_no_stimulation_spont_Hypo');
save('stand_no_stimulation_spont_Hyper','stand_no_stimulation_spont_Hyper');

save('stand_stimulation_stim_Hypo','stand_stimulation_stim_Hypo');
save('stand_stimulation_stim_Hyper','stand_stimulation_stim_Hyper');
save('stand_stimulation_spont_Hypo','stand_stimulation_spont_Hypo');
save('stand_stimulation_spont_Hyper','stand_stimulation_spont_Hyper');

save('run_stimulation_stim_Hypo','run_stimulation_stim_Hypo');
save('run_stimulation_stim_Hyper','run_stimulation_stim_Hyper');
save('run_stimulation_spont_Hypo','run_stimulation_spont_Hypo');
save('run_stimulation_spont_Hyper','run_stimulation_spont_Hyper');

save('run_NOstimulation_stim_Hypo','run_NOstimulation_stim_Hypo');
save('run_NOstimulation_stim_Hyper','run_NOstimulation_stim_Hyper');
save('run_NOstimulation_spont_Hypo','run_NOstimulation_spont_Hypo');
save('run_NOstimulation_spont_Hyper','run_NOstimulation_spont_Hyper');
