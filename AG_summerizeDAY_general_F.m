function [SummerizeDay] =  AG_summerizeDAY_general_F (Imaging_Days, Struct_, SummerizedVariable )
% input: 
%Imaging_DaysHyper_spont => Imaging_Days
% HyperStruct_spont_ => Struct_
% S_or => SummerizedVariable
Artificial_fps=10;Default_fps=4.36;
%output:  a cell array with the result

SummerizeDay=cell(2,numel(Imaging_Days));%initialize the cell array
for iDay=1:numel(Imaging_Days)  
    temp=[]; SummerizedVariable_Vec=[]; FOV=0;
    for iEX=1:numel(Struct_)
        if strcmp(Struct_(iEX).daysAfterBaseline, Imaging_Days(iDay))
           SummerizedVariable_Vec= mean(Struct_(iEX).(SummerizedVariable),2);
           if Struct_(iEX).fps%the if is for a case we dont have the fps info
             SummerizedVariable_Vec= (SummerizedVariable_Vec .* Artificial_fps) ./ Struct_(iEX).fps; %this sets the results to be per 100msec
           else
               SummerizedVariable_Vec= (SummerizedVariable_Vec .* Artificial_fps) ./Default_fps;

           end
           temp=[temp;SummerizedVariable_Vec];%adding the vector values to temp below the formers
           SummerizeDay{3+FOV,iDay}=SummerizedVariable_Vec;
           FOV=FOV+1;
        end %of if matched day    
    end
    SummerizeDay{1,iDay}=Imaging_Days(iDay);%title
    SummerizeDay{2,iDay}=temp;    %a cell with all the values
end
