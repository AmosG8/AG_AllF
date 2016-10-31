function [SummerizeDay]=Summerize_Corr_Day(dataset,prmts)

%% 1.  find the days in which there was imaging and place them in a vector
%Imaging_Days is [ 'DAY_0' 'DAY_1'  'DAY_14' 'DAY_28' 'DAY_4'  'DAY_7' ]
Imaging_Days = unique(extractfield(dataset, 'daysAfterBaseline'));

%% 2. make the cell array (SummerizeDay) output
SummerizeDay=cell(2,numel(Imaging_Days)*4);%initialize the cell array
%SummerizeDay_X has 4 columns for each day for: Xpos Ypos Xneg Yneg
%1st row is a tittle
%2nd row is a collection of all cells of that day
%other rows are for each FOV
for iDay=1:numel(Imaging_Days)  
    FOV=0;    tempXpos=[];tempYpos=[];tempXneg=[];tempYneg=[];
    for iEX=1:numel(dataset)%going over all experiments verify if they match the day
        if strcmp(dataset(iEX).daysAfterBaseline, Imaging_Days(iDay))
           [Xpos, Ypos, Xneg, Yneg]=AG_computeXcorrAnalysis(dataset(iEX),prmts);
           SummerizeDay{FOV+3,(iDay-1)*4+iDay}=Xpos; 
           SummerizeDay{FOV+3,(iDay-1)*4+iDay+1}=Ypos;  
           SummerizeDay{FOV+3,(iDay-1)*4+iDay+2}=Xneg;
           SummerizeDay{FOV+3,(iDay-1)*4+iDay+3}=Yneg;
           
           tempXpos=[tempXpos;Xpos];%adding the values to temp below the formers
           tempYpos=[tempYpos;Ypos];
           tempXneg=[tempXneg;Xneg];
           tempYneg=[tempYneg;Yneg];
           FOV=FOV+1;
        end %of a matched day
    end %going over the experiments, meaning i finished going through all ex of that day  
    %tittles
    SummerizeDay{1,(iDay-1)*4+iDay}=strcat(Imaging_Days(iDay), '_Xpos');
    SummerizeDay{1,(iDay-1)*4+iDay+1}=strcat(Imaging_Days(iDay), '_Ypos');
    SummerizeDay{1,(iDay-1)*4+iDay+2}=strcat(Imaging_Days(iDay), '_Xneg');
    SummerizeDay{1,(iDay-1)*4+iDay+3}=strcat(Imaging_Days(iDay), '_Yneg');
    
    SummerizeDay{2,(iDay-1)*4+iDay}=tempXpos;    %a cell with all the value
    SummerizeDay{2,(iDay-1)*4+iDay+1}=tempYpos; 
    SummerizeDay{2,(iDay-1)*4+iDay+2}=tempXneg; 
    SummerizeDay{2,(iDay-1)*4+iDay+3}=tempYneg; 

end%going over the days
