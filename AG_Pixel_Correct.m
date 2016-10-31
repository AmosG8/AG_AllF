%function AG_Pixel_Correct
clearvars;
%pixel offset correction
%this function deltes every other row and condenses the coloumns to half
addpath(genpath('/data/Amos'))
[fname,path]=uigetfile('*.tif'); 
cd(path);
%load (fullfile(path ,fname));
info = imfinfo(fname);
num_images = numel(info); %=how many frames I have

% [nRows,nCols]=size(imread(fname, 1));%read the 1st frame for initiating STK with zeroes
% STK = zeros(nRows,nCols,num_images); %,'uint16'
% STK=STK(1:2:end,:,:);

for k = 1:num_images
    [CurrentFrame,map] = imread(fname, k);
    CurrentFrame=CurrentFrame(1:2:end,:); %1:2:end removes all the odd rows, : leaves all the coloumns
    CurrentFrame = imresize(CurrentFrame,[size(CurrentFrame,1) size(CurrentFrame,2)/2]); %condence the columns
    STK(:,:,k)=CurrentFrame;
end
fname=fname(1:end-8);
PixCorrFileName = strcat(fname,'_PixCorCh1');
cd(path);%added
[FileName,PathName,FilterIndex] = uiputfile('*.tif','Save file for motion correction',PixCorrFileName);
ptr2file=fullfile(PathName,FileName);
maketiff(STK,ptr2file);
