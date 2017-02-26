%this script splices S-Or and C_df according running/no running and
%stimulus present/unpresent (time window of 500msec 
%% initialization
clear;
responseWindow=500; %in 4.36 scanning rate it means 2 frames
load ('EP_FILES_COMPILED');
default_fps=4.36;
Puff_interval=15;% sec
Mov_threshold=120;%we got this by comparing a moving carosel to not moving 
                            %120 by eye seems like the treshold for movement. 
Samples_Per_Frame=1000;  %i used 1000
        
%% going over the rows and computing which frames belong to which condition
% run_no_stim, run_stim, stand_no_stim, stand_stim

for iEX=1:numel(EP_FILES_COMPILED)
    EP_FILES_COMPILED(iEX).run_stim = [];
    EP_FILES_COMPILED(iEX).run_no_stim = [];
    EP_FILES_COMPILED(iEX).stand_stim = [];
    EP_FILES_COMPILED(iEX).stand_no_stim =[];
    
    EP_FILES_COMPILED(iEX).C_df_run_stim = [];
    EP_FILES_COMPILED(iEX).C_df_run_no_stim = [];
    EP_FILES_COMPILED(iEX).C_df_stand_stim = [];
    EP_FILES_COMPILED(iEX).C_df_stand_no_stim =[];
    
    if (~isempty(EP_FILES_COMPILED(iEX).StimVector)) ... %if there is analog1 
        && (~isempty(EP_FILES_COMPILED(iEX).S_or))%and if there's a file to analyze
        %I'll need the fps so first am getting it
        if ~isempty(EP_FILES_COMPILED(iEX).fps)%if there is content in fps
            fps=EP_FILES_COMPILED(iEX).fps;
        else
            fps=default_fps;
        end

            %% find stim frames indexes
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
        stim_frames = zeros(1,frames);%length(S_or) is the number of frames b/e there are always more frmames than cells
        if ~isempty(stim_indexes)
            % change stim_indexes to a vector of 0s and 1s according the indexes 
            
            fprintf('the response window is up to 500 msec \n');
            col_window=1/fps*1000;%the time duration of a frame
            while (col_window <responseWindow) && (max(stim_indexes) < (frames+1))  %+1 to allow last frame to pass%the response window is up to 500 msec
                stim_frames(1,stim_indexes)=1;%this sets the first element to 1
                stim_indexes=stim_indexes+1;%this will continue to add 1 until the end of the window
                col_window=col_window+1/fps*1000;
            end
        end
        %         figure();
        %         plot(stim_frames);

 % if there is analog1 there's also analog 2 
 %% find the running frames. 
        run_frames=zeros(1,frames);   
        q = EP_FILES_COMPILED(iEX).SpeedVector;  
        if (length(q)/ 1000) ~= (length(p)/ 1000)
            fprintf('ERROR there is a mismatch between the two analog files in ex %d \n', iEX);
            continue;
        end
        a = (q>Mov_threshold);%a contains 0 or 1.
        ResultIndex=1;
        %1000 samples per frame;
        for MeanCounter = 1:frames % the mean for every frame:
            FirstSampleInTimeBin=1+((MeanCounter-1)*1000);%FirstSampleInTimeBin is index for the sampling 
            LastSampleInTimeBin=((MeanCounter)*1000); 
            temp=mean(a (FirstSampleInTimeBin : LastSampleInTimeBin) );
            if temp > 0.5 
                run_frames(ResultIndex)=1;
            else 
                run_frames(ResultIndex)=0;
            end
            ResultIndex=ResultIndex+1;
        end
%         figure();
%         plot(a);

        %% separate S_or into the 4 matrixes
        S_or=EP_FILES_COMPILED(iEX).S_or;
        EP_FILES_COMPILED(iEX).run_stim = S_or(:,stim_frames & run_frames);  %both stim_frames and run_frames = 1
        EP_FILES_COMPILED(iEX).run_no_stim = S_or(:,~stim_frames & run_frames);  %stim_frames isn't 1, and run_frames = 1
        EP_FILES_COMPILED(iEX).stand_stim = S_or(:,stim_frames & ~run_frames);  %stim_frames is 1, and run_frames = 0
        EP_FILES_COMPILED(iEX).stand_no_stim = S_or(:,~stim_frames & ~run_frames);  %stim_frames is 0, and run_frames = 0
        
        if (~isempty(EP_FILES_COMPILED(iEX).C_df))
            C_df=EP_FILES_COMPILED(iEX).C_df;
            EP_FILES_COMPILED(iEX).C_df_run_stim = C_df(:,stim_frames & run_frames);  %both stim_frames and run_frames = 1
            EP_FILES_COMPILED(iEX).C_df_run_no_stim = C_df(:,~stim_frames & run_frames);  %stim_frames isn't 1, and run_frames = 1
            EP_FILES_COMPILED(iEX).C_df_stand_stim = C_df(:,stim_frames & ~run_frames);  %stim_frames is 1, and run_framse = 0
            EP_FILES_COMPILED(iEX).C_df_stand_no_stim = C_df(:,~stim_frames & ~run_frames);  %stim_frames is 0, and run_frames = 0
        else
            EP_FILES_COMPILED(iEX).C_df_run_stim = [];
            EP_FILES_COMPILED(iEX).C_df_run_no_stim = [];
            EP_FILES_COMPILED(iEX).C_df_stand_stim = [];
            EP_FILES_COMPILED(iEX).C_df_stand_no_stim =[];
        end
    else  % I don't have analog1
        EP_FILES_COMPILED(iEX).run_stim = [];
        EP_FILES_COMPILED(iEX).run_no_stim = [];
        EP_FILES_COMPILED(iEX).stand_stim = [];
        EP_FILES_COMPILED(iEX).stand_no_stim =[];
        
        EP_FILES_COMPILED(iEX).C_df_run_stim = [];
        EP_FILES_COMPILED(iEX).C_df_run_no_stim = [];
        EP_FILES_COMPILED(iEX).C_df_stand_stim = [];
        EP_FILES_COMPILED(iEX).C_df_stand_no_stim =[];
    end    %if there was analog file
end %of the going through the rows of corEP_files 
save ('EP_FILES_COMPILED','EP_FILES_COMPILED');