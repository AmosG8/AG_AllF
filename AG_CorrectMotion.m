%% Generates the initial ms data struct for data set contained in current folder
 %This is based on msRun
 %20-july-2016
 % It will save the corrected movie as a tiff (within ms2tiff there is an option to display 
 % % Receive an avi filename that ends with 1.avi
 
[filename,path]=uigetfile('*.avi'); 
%addpath(genpath(path));
filename=filename(1:end-5);  % the script needs an avi filename that ends with ch and not ch1
ms=msGenerateVideoObj(path, filename);
ms = msColumnCorrection(ms,5); %Generally not used 
ms = msFluorFrameProps(ms);

%% Select fluorescnece thesh for good frames
ms = msSelectFluorThresh(ms);

%% Allows user to select ROIs for each data folder
ms = msSelectROIs(ms);
%% Run alignment across all ROIs
plotting = true;
tic
ms = msAlignmentFFT(ms,plotting);
toc
%% Calculate mean frames
downsample = 5;
ms = msMeanFrame(ms,downsample);

%% Manually inspect and select best alignment
%the user selects which ROI to use as an anchor
ms = msSelectAlignment(ms); 

%% Save the corrected movie as a tiff (within ms2tiff there is an option to display 
%both the corrected and the uncorrected movies
%cd=('Z:\Amos');

MotionCorrFileName = strcat(filename,'_MotionCor');
[FileName,PathName,FilterIndex] = uiputfile('*.tif','Save file on Z',MotionCorrFileName);
ptr2file=fullfile(PathName,FileName);
AG_ms2tiff(ms,ptr2file,1,FileName); %the 1 means there will be motion correction
%AG_ms2tiff generates the Max projection
  % AG added FileName as an input to AG_ms2tiff 18/8/1


TO_save_Uncorrected=0;%change if you wanto to view the uncorrected file
if TO_save_Uncorrected
    FileName=FileName(1:end-13); 
    FileName=strcat(FileName,'NOT_corrected.tif');
    ptr2file=fullfile(PathName,FileName);
    AG_ms2tiff(ms,ptr2file,0,FileName); %the 0 means there won't be motion correction
end   

%%
%to save a max projection

