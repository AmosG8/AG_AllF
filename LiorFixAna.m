FaultyFileName ='';
for LineNumber=1:numel(EP_FILES_COMPILED)
    if( strcmp(EP_FILES_COMPILED(LineNumber).dataFileName, FaultyFileName)
        TempSpeed = EP_FILES_COMPILED(LineNumber).StimVector;
        TempStim  = EP_FILES_COMPILED(LineNumber).SpeedVector;
        EP_FILES_COMPILED(LineNumber).StimVector = TempStim;
        AG_NEW_EP_FILES_COMPILED(LineNumber).SpeedVector = TempSpeed;
        
        clear TempSpeed TempStim;
        break;
    end
end
        