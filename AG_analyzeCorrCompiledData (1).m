%summerize xcross analysis of the whole data set
%AG 13/9/16
%former versions: AG_analyzeCompiledData based on PB nalyzeCompiledData.
%the entry poins is the structure generated by "gatherCalciumMatFiles"
%path2sourceDir =  '/Users/pb/Data/PBLab/David/Testing'; %point to directory containing experiment database
path2sourceDir = '/data/Amos/TAC';
compiledFileName = 'EP_FILES_COMPILED.mat';
path2resDir = [path2sourceDir filesep 'RESULTS'];

%% define analysis parameters

prmts.doComputeXcorr = 1;
prmts.doComputeSHIFT = 0;
prmts.doComputeSVD = 0;
prmts.doSubsampleImg = 1;
prmts.minCorrValToPlotEdges = 0.6;


if ~isdir(path2resDir)
    mkdir(path2resDir);
end

%% load data - data is saved as structure array
load (fullfile(path2sourceDir,compiledFileName));
compiledFileNameNew=compiledFileName(1:end-4);
EP=eval(compiledFileNameNew);

%% AG added: separate the 'EP files compiled'-dataset-structure to 4 structures:
%  EP_Spont_Hypo
%  EP_SPont_Hyper
%  EP_Stim_Hypo
%  EP_Stim_Hyper
temp=SpontStim(EP,'SPONT');%this give all Spont ex that are both hyper and hypo
EP_Spont_Hypo=HypoHyper(temp,'HYPO-TAC');
EP_SPont_Hyper=HypoHyper(temp,'HYPER-TAC');

temp=SpontStim(EP,'STIM');
EP_Stim_Hyper=HypoHyper(temp,'HYPER-TAC');
EP_Stim_Hypo=HypoHyper(temp,'HYPO-TAC');

%% make cell arrays that contain same day data out of the structures done in section 2 
% the data has to be Xpos Ypos Xneg Yneg from computeXcorr
% spont_Hyper
SummerizeDay_Spont_Hyper = Summerize_Corr_Day(EP_SPont_Hyper,prmts);
SummerizeDay_Spont_Hypo = Summerize_Corr_Day(EP_Spont_Hypo,prmts);
SummerizeDay_Stim_Hyper = Summerize_Corr_Day(EP_Stim_Hyper,prmts);
SummerizeDay_Stim_Hypo = Summerize_Corr_Day(EP_Stim_Hypo,prmts);
%%
save('Corr_stim_Hypo.mat','SummerizeDay_Stim_Hypo');
save('Corr_stim_Hyper','SummerizeDay_Stim_Hyper');
save('Corr_spont_Hypo','SummerizeDay_Spont_Hypo');
save('Corr_spont_Hyper','SummerizeDay_Spont_Hyper');

%% bin data across all FOVs
% bin=50;
% Maxdis=300;
% %hypo
% X=SummerizeDay_Spont_Hypo{2,1};%col 1 is for day0. 
% %row 2 is for all the cells. 
% Y=SummerizeDay_Spont_Hypo{2,2}; 
% DayZeroSpontHypo=AG_BinCorr('Spont_Hypo',X,Y,bin,Maxdis);
% %Hyper
% X=SummerizeDay_Spont_Hyper{2,1};
% Y=SummerizeDay_Spont_Hyper{2,2};
% DayZeroSpontHyper=AG_BinCorr('Spont_Hyper',X,Y,bin,Maxdis);

%% bin data in each cell
bin=50;
Maxdis=300;
FOVbinned_Spont_Hypo=FOVbinned('Spont_Hypo', SummerizeDay_Spont_Hypo,bin,Maxdis);
FOVbinned_Spont_Hyper=FOVbinned('Spont_Hyper', SummerizeDay_Spont_Hyper,bin,Maxdis);

