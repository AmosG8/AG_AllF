% print A cell array to file

%% prepare the number of columns
s1='%d';colnumString='%d';
ColNum=input('how many columns are there? has to be more than 1');
for iii=1:ColNum-1
    colnumString=strcat(s1,' ,',colnumString);  
end
    colnumString=strcat(colnumString, '\n');
    %% now write the cell array to a file that contains the input number of columns
    fileID = fopen('TargetFile.dat','w');
    formatSpec = colnumString;%'%d %d %d %d %d %d \n';
    [nrows,ncols] = size(A);
    for row = 1:nrows
        fprintf(fileID,formatSpec,A{row,:});
    end
    fclose(fileID);
