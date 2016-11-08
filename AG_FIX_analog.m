%fix for not using the analouge files
clear;
fps=0;
MAT_filename = uigetfile('*.mat','Select the file that is begining with MAT');
% cd_path=input('cd','s');
% cd(cd_path);
% MAT_filename=input('name','s');
load(MAT_filename);
%check if we had the analog files
anal=input('do u have the analog files? 0=no, 1=yes \n');
if anal
    if fps >0%because sometimes we didn't have this info
        stim_frames = AG_FindAirPuffTImes(fps);% returns a vector of the indexes of the first frame of each stim
        run_frames = AG_FindMovTIme;%returns a vector of the indexes of the running frames
    else
       stim_frames = AG_FindAirPuffTImes(4.36);% 4.36 is the default
       run_frames = AG_FindMovTIme;%returns a vector of the indexes of the running frames
    end
    %Separate_Data into 4 matrixes
    run_stim = S_or(:,stim_frames & run_frames);  %both stim_frames and run_frames = 1
    run_no_stim = S_or(:,~stim_frames & run_frames);  %stim_frames isn't 1, and run_frames = 1
    stand_stim = S_or(:,stim_frames & ~run_frames);  %stim_frames is 1, and run_frames = 0
    stand_no_stim = S_or(:,~stim_frames & ~run_frames);  %stim_frames is 1, and run_frames = 0
else  % I don't have the analog files
    run_stim = [];
    run_no_stim = [];
    stand_stim = [];
    stand_no_stim =[];
end


MAT_filename=strcat(MAT_filename(1:end-4),'FiiX.mat');
%save(MAT_filename);

