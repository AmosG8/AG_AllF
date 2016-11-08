%% initialization
clear;
load (corEP_FILES_COMPILED);
default_fps=4.36;
Puff_interval=15;%sec
Mov_threshold=120;%we got this by comparing a moving carosel to not moving 
                            %120 by eye seems like the treshold for movement. 
%Samples_Per_Frame=1000;  %i used 1000
%% going over the rows and computing 
% run_no_stim, run_stim, stand_no_stim, stand_stim

for iEX=1:numel(corEP_FILES_COMPILED)
    %I'll need the fps so first am getting it
    if ~isempty(corEP_FILES_COMPILED(iEX).fps)%if there is content in fps
        fps=corEP_FILES_COMPILED(iEX).fps;
    else
        fps=default_fps;
    end
    
    %do i have an analog1 file  = air puff info
    if ~isempty(corEP_FILES_COMPILED(iEX).StimVector)%if there is analog1 
        
        %find stim frames indexes
        p =corEP_FILES_COMPILED(iEX).StimVector; %that's a vector with all the sampling
        NumFrames=length(p)./ 1000; %1000 samples per frame
        RecordingDuration = NumFrames ./ fps;
        t = linspace(0,RecordingDuration,length(p)); %
        MinPeakDistance = Puff_interval * 1000;%this is for 15 sec interval between puffs
        [PKS ,LOCS] = findpeaks(double(p),'MINPEAKHEIGHT',100,'MINPEAKDISTANCE', MinPeakDistance);
        times=t(LOCS); %that's the answer in sec. I'll now change it to frames
        stim_indexes=floor(fps*times);%Floor rounds it to the frame in which the stim began
        if isempty(stim_indexes)
            stim_indexes(1,1)= 0;
        end
        if stim_indexes(1,1)== 0
            stim_indexes=1;
        end
        
        % change stim_indexes to a vector of 0s and 1s according the indexes 
        stim_frames = zeros(1,NumFrames);
        fprintf('the response window is up to 500 msec \n');
        col_window=1/fps*1000;%the time duration of a frame
        while col_window <500 %the response window is up to 500 msec
            stim_frames(1,stim_indexes)=1;%this sets the first element to 1
            stim_indexes=stim_indexes+1;%this will continue to add 1 until the end of the window
            col_window=col_window+1/fps*1000;
        end
        figure();
        plot(stim_frames);

 % if there is analog1 there's also analog 2 
 % so now find the running frames. 
           
        p = corEP_FILES_COMPILED(iEX).SpeedVector;  
        a = (p>Mov_threshold);%a contains 0 or 1.
        Former_Mean_Couner=1;
        ResultIndex=1;
        for MeanCounter = 1:NumFrames
            FirstSampleInTimeBin=1+((MeanCounter-1)*1000);
            LastSampleInTimeBin=((MeanCounter)*10000); 
            temp=mean(a (FirstSampleInTimeBin : LastSampleInTimeBin) );
            if temp > 0.5
                run_frames(ResultIndex)=1;
            else
                run_frames(ResultIndex)=0;
            end
            ResultIndex=ResultIndex+1;
        end
        figure();
        plot(a);

        %separate S_or into the 4 matrixes
        
        run_stim = corEP_FILES_COMPILED(iEX).S_or(:,stim_frames & run_frames);  %both stim_frames and run_frames = 1
        run_no_stim = corEP_FILES_COMPILED(iEX).S_or(:,~stim_frames & run_frames);  %stim_frames isn't 1, and run_frames = 1
        stand_stim = corEP_FILES_COMPILED(iEX).S_or(:,stim_frames & ~run_frames);  %stim_frames is 1, and run_frames = 0
        stand_no_stim = corEP_FILES_COMPILED(iEX).S_or(:,~stim_frames & ~run_frames);  %stim_frames is 1, and run_frames = 0
    else  % I don't have analog1
        run_stim = [];
        run_no_stim = [];
        stand_stim = [];
        stand_no_stim =[];
    end    
end %of the going through the rows of corEP_files 