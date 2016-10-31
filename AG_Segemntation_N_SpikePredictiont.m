%This is based on the demo_script from Eftychios Pnevmatikakis
%This code asks for a tiff and does segmentation and spike prediction.

%% clear;
clearvars; %AG changed clear to clearvars;
%% Path in use
% addpath(genpath('utilities'));
% addpath(genpath('/data/Amos/ca_source_extraction-master_20_7_16'));
% addpath(genpath('Z:/Amos'));
% cd=('Z:\Amos');  %filesep 

% Createpath= ['Z:' filesep 'Amos' filesep 'ca_source_extraction-master_20_7_16' filesep...
%     'utilities' filesep 'bigread2.m'];
% addpath(Createpath);
%% load file
[FileName,PathName,FilterIndex] = uigetfile('*.tif','Select a motion corrected movie');
nam=fullfile(PathName,FileName);
%nam='/home/amos/ca_source_extraction/movie1_frame_300_300_10.46pfs_mag_2_puff-Ch1.tif';
sframe=1;						% user input: first frame to read (optional, default 1)
num2read=length(imfinfo(nam));
%num2read=2000;					% user input: how many frames to read   (optional, default until the end)

Y = bigread2(nam,sframe,num2read);
Y = Y - min(Y(:)); 
if ~isa(Y,'double');    Y = double(Y);  end            % convert to single

[d1,d2,T] = size(Y);                                % dimensions of dataset
d = d1*d2;                                          % total number of pixels

%% Set parameters
K = input('How many cells are in the field?\n');  % number of components to be found
tau = 3;                                          % std of gaussian kernel (size of neuron) 
p = 2;                                            % order of autoregressive system (p = 0 no dynamics, p=1 just decay, p = 2, both rise and decay)
merge_thr = 0.8; % merging threshold
fprintf('sababa, remember that other parameters are in default and can be changed within Ag_segemnetation_N_Spike...\n')
fps=4.36;
ChangeFpS=input('is the frame rate different from 4.36 frame/sec? \n   1 for yes (it is NOT 4.36) ;  0 for it is 4.36 \n');
if ChangeFpS
    fps=input( 'What is the frame rate?\n');
end
options = CNMFSetParms(...                      
    'd1',d1,'d2',d2,...                         % dimensions of datasets
    'search_method','dilate','dist',3,...       % search locations when updating spatial components
    'deconv_method','constrained_foopsi',...    % activity deconvolution method
    'temporal_iter',2,...                       % number of block-coordinate descent steps 
    'fudge_factor',0.98,...                     % bias correction for AR coefficients
    'merge_thr',merge_thr,...                    % merging threshold
    'gSig',tau...
    );
%% Data pre-processing

[P,Y] = preprocess_data(Y,p);

%% fast initialization of spatial components using greedyROI and HALS

[Ain,Cin,bin,fin,center] = initialize_components(Y,K,tau,options,P);  % initialize

% display centers of found components
Cn =  correlation_image(Y); %correlation_image(Y); %max(Y,[],3); %std(Y,[],3); % image statistic (only for display purposes)
%reshape(P.sn,d1,d2);  %max(Y,[],3); %std(Y,[],3); % image statistic (only for display purposes)
figure;imagesc(Cn);
    axis equal; axis tight; hold all;
    scatter(center(:,2),center(:,1),'mo');
    title('Center of ROIs found from initialization algorithm');
    drawnow;

%% manually refine components (optional)
refine_components = 1;%input('manually refine components?\n 0 for no 1 for yes\n');
%refine_components = true;  % flag for manual refinement
if refine_components
    [Ain,Cin,center] = manually_refine_components(Y,Ain,Cin,center,Cn,tau,options);
end
    
%% update spatial components
Yr = reshape(Y,d,T);
%clear Y;
[A,b,Cin] = update_spatial_components(Yr,Cin,fin,[Ain,bin],P,options);
%% update temporal components
P.p = 0;    % set AR temporarily to zero for speed
[C,f,P,S,YrA] = update_temporal_components(Yr,A,b,Cin,fin,P,options);

%% merge found components
[Am,Cm,K_m,merged_ROIs,Pm,Sm] = merge_components(Yr,A,b,C,f,P,S,options);
%%
display_merging = 0; % flag for displaying merging example..   AG changed to 0 ; 22-8-16
if and(display_merging, ~isempty(merged_ROIs))
    i = 1; %randi(length(merged_ROIs));
    ln = length(merged_ROIs{i});
    figure;
        set(gcf,'Position',[300,300,(ln+2)*300,300]);
        for j = 1:ln
            subplot(1,ln+2,j); imagesc(reshape(A(:,merged_ROIs{i}(j)),d1,d2)); 
                title(sprintf('Component %i',j),'fontsize',16,'fontweight','bold'); axis equal; axis tight;
        end
        subplot(1,ln+2,ln+1); imagesc(reshape(Am(:,K_m-length(merged_ROIs)+i),d1,d2));
                title('Merged Component','fontsize',16,'fontweight','bold');axis equal; axis tight; 
        subplot(1,ln+2,ln+2);
            plot(1:T,(diag(max(C(merged_ROIs{i},:),[],2))\C(merged_ROIs{i},:))'); 
            hold all; plot(1:T,Cm(K_m-length(merged_ROIs)+i,:)/max(Cm(K_m-length(merged_ROIs)+i,:)),'--k')
            title('Temporal Components','fontsize',16,'fontweight','bold')
        drawnow;
end

%% repeat
Pm.p = p;    % restore AR value
[A2,b2,Cm] = update_spatial_components(Yr,Cm,f,[Am,b],Pm,options);
[C2,f2,P2,S2,YrA2] = update_temporal_components(Yr,A2,b2,Cm,f,Pm,options);

%% do some plotting

[A_or,C_or,S_or,P_or] = order_ROIs(A2,C2,S2,P2); % order components
K_m = size(C_or,1);
[C_df,~] = extract_DF_F(Yr,A_or,C_or,P_or,options); % extract DF/F values (optional)%AG - was commented by mistake

%contour_threshold = 0.95;                       % amount of energy used for each component to construct contour plot
figure;
[Coor,json_file] = plot_contours(A_or,Cn,options,1); % contour plot of spatial footprints
%savejson('jmesh',json_file,'filename');        % optional save json file with component coordinates (requires matlab json library)
%% display components

plot_components_GUI(Yr,A_or,C_or,b2,f2,Cn,options)

%% make movie

%make_patch_video(A_or,C_or,b2,f2,Yr,Coor,options)

%% AG is adding this to split S_or according running/standing stim/no stim
Separate=input('do u have the analog files? 0=no, 1=yes \n');
if Separate
    %first get the 'stim_frames' and the 'run_frames'
    stim_frames = AG_FindAirPuffTImes(fps);% returns a vector of the indexes of the first frame of each stim
    run_frames = AG_FindMovTIme;%returns a vector of the indexes of the running frames

    %Separate_Data into 4 matrixes
    run_stim = S_or(:,stim_frames & run_frames);  %both stim_frames and run_frames = 1
    run_no_stim = S_or(:,~stim_frames & run_frames);  %stim_frames isn't 1, and run_frames = 1
    stand_stim = S_or(:,stim_frames & ~run_frames);  %stim_frames is 1, and run_frames = 0
    stand_no_stim = S_or(:,~stim_frames & ~run_frames);  %stim_frames is 1, and run_frames = 0
%     if length(stand_no_stim)>0
%         filenameD = strcat(FileName,'_stand_no_stim');
%         xlswrite(filenameD,stand_no_stim);
%     end
end
%%
FileName=FileName(1:end-5); %remove the .tif
FileName=strcat('MAT_',FileName,'.mat');
save(FileName);%movie2_for_arb2_mag_2_fr_4p36_for_AMOS_part2_puff_PixCorCh_MotionCor.tif
MovieIdentity=strcat(PathName,'_', FileName);
