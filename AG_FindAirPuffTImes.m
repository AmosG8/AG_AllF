function[stim_frames]= AG_FindAirPuffTImes(FrameRate)
%AG 16.8.16
%p = Ch3_analog.Ch3;

%it returns a vector of 0's and 1's where the 1's indicate frames of the response
%window.
[filename,path2file] = uigetfile('*.*','select Ch3_analog1');
load (fullfile(path2file ,filename));
p = Ch3_analog.Ch3;


%FrameRate = input('What is the frame rate (Frames per second) ? \n'); 
NumFrames=Ch3_analog.num_frames;

%%  
RecordingDuration = NumFrames ./ FrameRate;
NumSamples = NumFrames .* 1000; % 1000 samples per frame
t = linspace(0,RecordingDuration,NumSamples); %
MinPeakDistance = 15 * 1000;%this is for 15 sec interval between puffs
[PKS ,LOCS] = findpeaks(double(p),'MINPEAKHEIGHT',100,'MINPEAKDISTANCE', MinPeakDistance);

times=t(LOCS); %that's the answer. 
stim_indexes=floor(FrameRate*times);%Floor rounds it to the frame in which the stim began
if isempty(stim_indexes)
    stim_indexes(1,1)= 0;
end
if stim_indexes(1,1)== 0
    stim_indexes=1;
end
%stim_indexes
%% change stim_frames to a vector of 0s and 1s according the indexes 
stim_frames = zeros(1,NumFrames);
fprintf('the response window is up to 500 msec \n');
col_window=1/FrameRate*1000;
while col_window <500 %the response window is up to 500 msec
    stim_frames(1,stim_indexes)=1;%this sets the first element to 1
    stim_indexes=stim_indexes+1;%this will continue to add 1 until the end of the window
    col_window=col_window+1/FrameRate*1000;
end
figure(114);
plot(stim_frames);
