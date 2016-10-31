%the aim here is to say for each frame if the mouse run in it or not.
%load the file using import

Mov_threshold=120;  %we got this by comparing a moving carosel to not moving 
                    %120 by eye seems like the treshold for movement. 
Samples_Per_Frame=1000;
clear answer;
%%
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
        answer(ResultIndex)=1;
    else
        answer(ResultIndex)=0;
    end
ResultIndex=ResultIndex+1;
end
% figure(111);
% plot(a);
figure(112);
plot(answer);


