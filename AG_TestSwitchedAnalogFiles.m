% run over the experiemts 
 %sisplay a figure for each ex with 4 sub-plots
 % 1. puff times if analog1 is the puff
 % 2. puff times if analog2 is the puff
 % 3. mov times if analog 1 is the mov
 % 4. mov times if analog2 is the mov
 
 % pause and wait for user input if to swtich
% clode figure and go to the begining of the loop


%% initialization
clear;
load ('EP_FILES_COMPILED');
default_fps=4.36;
Puff_interval=15;%sec
Mov_threshold=120;%we got this by comparing a moving carosel to not moving 
                            %120 by eye seems like the treshold for movement. 
Samples_Per_Frame=1000;  %i used 1000
responseWindow=500;%msec
%% 
for iEX=1:numel(EP_FILES_COMPILED)  
    if (~isempty(EP_FILES_COMPILED(iEX).StimVector)) ... %if there is analog1 
    && (~isempty(EP_FILES_COMPILED(iEX).S_or))%and if there's a file to analyze
        if ~isempty(EP_FILES_COMPILED(iEX).fps)%if there is content in fps
            fps=EP_FILES_COMPILED(iEX).fps;
        else
            fps=default_fps;
        end
     %% find stim frames based on analog1  =stim_framesByAnaOne
        p =EP_FILES_COMPILED(iEX).StimVector; %that's a vector with all the sampeling: 1000per frame   
        RecordingDuration = (length(p)./ 1000)./ fps; %1000 samples per frame
        t = linspace(0,RecordingDuration,length(p)); %
        samplesInterval=Puff_interval*Samples_Per_Frame*fps;%15 sec x 1000 samples/frame  x 4.36frames/sec
        [PKS ,LOCS] = findpeaks(double(p),'MinPeakHeight',100,'MINPEAKDISTANCE', samplesInterval);
        times=t(LOCS); %that's the answer in msec. I'll now change it to frames
        stim_indexes=floor(fps*times)+1;%Floor rounds it to the frame in which the stim began
        [cells,frames]=size(EP_FILES_COMPILED(iEX).S_or);
        if frames ~= (length(p)/ 1000)
            fprintf('ERROR mismatch between the analog files and the mat file from EP analysis in ex %d \n', iEX);
            continue;
        end
        stimByAnaOne = zeros(1,frames);%length(S_or) is the number of frames b/e there are always more frmames than cells
        if ~isempty(stim_indexes)
            % change stim_indexes to a vector of 0s and 1s according the indexes 
            
            fprintf('the response window is up to 500 msec \n');
            col_window=1/fps*1000;%the time duration of a frame
            while (col_window <responseWindow) && (max(stim_indexes) < (frames+1))  %+1 to allow last frame to pass%the response window is up to 500 msec
                stimByAnaOne(1,stim_indexes)=1;%this sets the first element to 1
                stim_indexes=stim_indexes+1;%this will continue to add 1 until the end of the window
                col_window=col_window+1/fps*1000;
            end
        end
        %% now again if the stim is based on speed (analog 2)
        p =EP_FILES_COMPILED(iEX).SpeedVector; %that's a vector with all the sampeling: 1000per frame   
        RecordingDuration = (length(p)./ 1000)./ fps; %1000 samples per frame
        t = linspace(0,RecordingDuration,length(p)); %
        samplesInterval=Puff_interval*Samples_Per_Frame*fps;%15 sec x 1000 samples/frame  x 4.36frames/sec
        [PKS ,LOCS] = findpeaks(double(p),'MinPeakHeight',100,'MINPEAKDISTANCE', samplesInterval);
        times=t(LOCS); %that's the answer in msec. I'll now change it to frames
        stim_indexes=floor(fps*times)+1;%Floor rounds it to the frame in which the stim began
        [cells,frames]=size(EP_FILES_COMPILED(iEX).S_or);
        if frames ~= (length(p)/ 1000)
            fprintf('ERROR mismatch between the analog files and the mat file from EP analysis in ex %d \n', iEX);
            continue;
        end
        stimByAnaTwo = zeros(1,frames);%length(S_or) is the number of frames b/e there are always more frmames than cells
        if ~isempty(stim_indexes)
            % change stim_indexes to a vector of 0s and 1s according the indexes 
            
            fprintf('the response window is up to 500 msec \n');
            col_window=1/fps*1000;%the time duration of a frame
            while (col_window <responseWindow) && (max(stim_indexes) < (frames+1))  %+1 to allow last frame to pass%the response window is up to 500 msec
                stimByAnaTwo(1,stim_indexes)=1;%this sets the first element to 1
                stim_indexes=stim_indexes+1;%this will continue to add 1 until the end of the window
                col_window=col_window+1/fps*1000;
            end
        end

 % if there is analog1 there's also analog 2 
 %% find the running times in mSec based on analog 2. 
        run_frames=zeros(1,frames);   
        q = EP_FILES_COMPILED(iEX).SpeedVector;  
        RunnungAna2 = (q>Mov_threshold);%a contains 0 or 1.
%         ResultIndex=1;
%         for MeanCounter = 1:NumFrames % the mean for every frame:
%             FirstSampleInTimeBin=1+((MeanCounter-1)*1000);%FirstSampleInTimeBin is index for the sampling 
%             LastSampleInTimeBin=((MeanCounter)*1000); 
%             temp=mean(a (FirstSampleInTimeBin : LastSampleInTimeBin) );
%             if temp > 0.5
%                 run_frames(ResultIndex)=1;
%             else
%                 run_frames(ResultIndex)=0;
%             end
%             ResultIndex=ResultIndex+1;
%         end
 %% find the running times in mSec based on analog 1(stim). 
        run_frames=zeros(1,frames);   
        q = EP_FILES_COMPILED(iEX).StimVector;  
        RunnungAna1 = (q>Mov_threshold);
%% make figure
        FileName=EP_FILES_COMPILED(iEX).dataFileName;
        fprintf('%s \n',FileName);
        
        figure(10);
        
        subplot(2,2,1); %top left
        plot(stimByAnaOne);
        FileName=strcat('stim', FileName(4:end-5));
        title(FileName);
        
        subplot(2,2,3);%buttom left
        plot(RunnungAna2);
        FileName=strcat('RUNING');
        title(FileName);
        
        subplot(2,2,2);
        plot(stimByAnaTwo);
        title('stim if switching');
        
        subplot(2,2,4);
        plot(RunnungAna1);
        title('running if switching');
%% user input if to switch
        ToSwitch=input('press 0 to leave as is on the left side, press 1 to switch');
        if ToSwitch
            temp=EP_FILES_COMPILED(iEX).SpeedVector;
            EP_FILES_COMPILED(iEX).SpeedVector=EP_FILES_COMPILED(iEX).StimVector;
            EP_FILES_COMPILED(iEX).StimVector=temp;
        end
        close(10);
     
     end %not empty   
end %main loop
save ('EP_FILES_COMPILED','EP_FILES_COMPILED');


