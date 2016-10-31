function [run_frames]=AG_FindMovTIme

%calculate  for each frame if the mouse run in it or not.


Mov_threshold=120;  %we got this by comparing a moving carosel to not moving 
                    %120 by eye seems like the treshold for movement. 
Samples_Per_Frame=1000;
clear run_frames;
%%
[filename,path2file] = uigetfile('*.*','select Ch4_analog2');
load (fullfile(path2file ,filename));
p = Ch4_analog.Ch4;

a = (p>Mov_threshold);%a contains 0 or 1.

Number_of_Frames= Ch4_analog.num_frames; %length(a)/Samples_Per_Frame;                                
Former_Mean_Couner=1;
ResultIndex=1;
for MeanCounter = 1:Number_of_Frames
    FirstSampleInTimeBin=1+((MeanCounter-1)*Samples_Per_Frame);
    LastSampleInTimeBin=((MeanCounter)*Samples_Per_Frame); 
    temp=mean(a (FirstSampleInTimeBin : LastSampleInTimeBin) );
    if temp > 0.5
        run_frames(ResultIndex)=1;
    else
        run_frames(ResultIndex)=0;
    end
ResultIndex=ResultIndex+1;
end
% figure(111);
% plot(a);
figure(112);
plot(run_frames);
% run_frames = find(answer);%return a vector with the indexes for the running frames


