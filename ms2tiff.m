function ms2tiff(ms,ptr2file,applyTransform)
%24-July-2016
% ms2tiff - converts object from mini-scope to tiff file while applying
% a computed spatial transform (this assumes the following sections of msRun.m
% where ran:
%     ms = msColumnCorrection(ms,5); %Generally not used 
%     ms = msFluorFrameProps(ms);
%     ms = msSelectFluorThresh(ms);
%     ms = msSelectROIs(ms);
%     ms = msAlignmentFFT(ms,plotting);
%     ms = msMeanFrame(ms,downsample);
%     ms = msSelectAlignment(ms);

%%
hSmall = fspecial('average', 3); % filters across 3 pixels
nRows = ms.alignedHeight(ms.selectedAlignment); % the size of the aligned matrix is smaller than the original matrix
nCols = ms.alignedWidth(ms.selectedAlignment); 

stk = zeros(nRows,nCols,ms.numFrames,'uint16'); 
DisplayMovies =0;
% DisplayMovies = input(['Display the corrected and the uncorrected movies?' ...
%  'Dispalying the movies takes much time!\n 0 for no; 1 for yes\n']);
for iFRM = 1:ms.numFrames   
    stk(:,:,iFRM) = uint16(filter2(hSmall,msReadFrame(ms,iFRM,true,applyTransform,0)));
    %DisplayMovies=0; %in case one wants to view the corrected movie change to 1
     if DisplayMovies
        subplot(1,2,1)
        thisFrame = filter2(hSmall,msReadFrame(ms,iFRM,true,0,0));
        imagesc(thisFrame);axis image;colormap hot;
        subplot(1,2,2)
        thisFrame = filter2(hSmall,msReadFrame(ms,iFRM,true,1,0));
        imagesc(thisFrame);axis image;colormap hot;
        title(num2str(iFRM));
        drawnow
     end
end
%%
maketiff(stk,ptr2file);