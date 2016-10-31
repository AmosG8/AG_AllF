%% Generates the initial ms data struct for data set contained in current folder
 %master code of the miniscope analysis package
%20-july-2016
[filename,path]=uigetfile; %a=filenmae
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
[FileName,PathName,FilterIndex] = uiputfile('*.tiff','Save file on Z','corrected');
ptr2file=fullfile(PathName,FileName);
ms2tiff(ms,ptr2file);
