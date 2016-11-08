% print a cell array to file

[FileName,PathName,FilterIndex] = uigetfile('.mat','select a cell array');
load(FileName);
VarName = FileName(1:end-4);
MyCellArray=eval(VarName);
ColNum=numel(MyCellArray(1,:));
%% prepare the number of columns
s1='%d';colnumString='%d';
%ColNum=input('how many columns are there? has to be more than 1');
for iii=1:ColNum-1
    colnumString=strcat(s1,' ,',colnumString);  
end
    colnumString=strcat(colnumString, '\n');
    %% now write the cell array to a file that contains the input number of columns
    targetString=strcat(VarName,'Target.csv');
    fileID = fopen(targetString,'w');
    formatSpec = colnumString;%'%d %d %d %d %d %d \n';
    [nrows,ncols] = size(MyCellArray);
    fprintf(fileID,formatSpec,MyCellArray{2,:});
    fclose(fileID);
