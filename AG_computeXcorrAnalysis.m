function [Xpos, Ypos, Xneg, Yneg] = AG_computeXcorrAnalysis(thisEXP,prmts)
%8-Sep-16
if thisEXP.C_df %AG added that if for a case there's no data
    %The following files have unclear problem and cause the code to fail
%     if ~strcmp (thisEXP.dataFileName, 'MAT_540_4d_noPuff_Part1_Motion_Pix_correcte.mat')...
%         && ~strcmp (thisEXP.dataFileName, 'MAT_999_HYPER_DAY_0_FOV_2_SPONT_PixCorCh_MotionCo.matFiiX.mat') 
        %...            
        prmts.doComputeSHIFT = 1;
        prmts.doComputeSVD = 0;
        prmts.doSubsampleImg = 0;%1;AG 12/12
        prmts.minCorrValToPlotEdges = 0.6;
        %AG uncommnented the 4 above lines
        fprintf ('%s \n', thisEXP.dataFileName);
        if prmts.doSubsampleImg
            img = thisEXP.maxProjImg;
            imgSize = size(img);
            img = imresize(img(1:2:end,:),imgSize/2);
        end
    %end %of strcmp
    %% get data
    %this is the C_df matrix of the EP analysis
    S_or = thisEXP.S_or; 
    Coor = thisEXP.Coor;
    dF = thisEXP.C_df;
    [nCells nT] = size(dF);
    %% plot traces
    plotTrace=0;
  if plotTrace  
    %add an increment to each dF line so they separate in the plot
    figure
    
    subplot(3,2,3)
    offset = [1:nCells]';
    offset = repmat(offset,1,nT);
    plot(1:nT,dF+offset)
    set(gca,'xcolor',[1 1 1].*0.5,'ycolor',[1 1 1].*0.5)
    grid on
    box off
    title('\DeltaF/F_{0}')
    ylabel('Cell ID')
    set(gca,'xticklabel',{})
    subplot(3,4,9)
    imagesc(log(S_or))
    colormap summer
    linkaxes(findobj(gcf,'type','axes'))
    set(gca,'xcolor',[1 1 1].*0.5,'ycolor',[1 1 1].*0.5,'ydir','normal')
    grid on
    box off
    title('Log ( S_{or} )')
    ylabel('Cell ID')
    xlabel('Frame')
  end   
    
    %% filtering
    % Low pass Butterworth filter - not sure we need this as we have the
    %estimaged traces after deconvolution of spike event (EP code or similar).
    
    %% cross correlate
    % compute cross correlation, normalized by the autocorrelation at zero lag
    %using the following (A x B)/[norm(A) * norm(B)] where A and B are the
    %"deconvolved" calcium vectors and "norm" outputs the Euclidean lenght of
    %each vector, Pearson correlation gives an identical answer...
    if issparse(dF);dF=full(dF);end
    [R,PR]=corrcoef(dF','rows','pairwise');
    
    %% plot an ordered correlation matrix based on distances on the the
    %correlation space
    if plotTrace
        D = pdist(R);
        tree = linkage(D,'average');
        leafOrder = optimalleaforder(tree,D);

        figure
        subplot(1,2,1)
        imagesc(R)
        axis square
        axis off
        colorbar

        subplot(1,2,2)
        imagesc(R(leafOrder,leafOrder))
        axis square
        axis off

        map  = colormap(summer);
        map(end,:)=[0.5 0.5 0.5];%gray out main diagonal
        colormap(map)

        colorbar
    end
    
    %% compute correlation as funciton of distance
    kpairs = nchoosek(1:nCells,2);
    nPairs = size(kpairs,1);
    
    %build adjacency matrix based on correlation coefficient (start by using
    %only significant correlation p<0.5)
    
    Adj = R.*(PR<0.001);
    AdjPos = Adj;
    AdjNeg = Adj;
    AdjPos(Adj<prmts.minCorrValToPlotEdges)=0;
    AdjNeg(Adj>-prmts.minCorrValToPlotEdges)=0;
    % figure;
    clf
%     imagesc(img)  AG commented
%     colormap(copper)
    hold on
    myctr = zeros(size(Adj,1),2);
    for iCOOR = 1 : numel(Coor)
        xi = Coor{iCOOR,1}(1,:);
        yi = Coor{iCOOR,1}(2,:);
        myctr (iCOOR,:) = [mean(xi) mean(yi)];
        %plot(xi,yi,'r.') AG commented
        %text(myctr(iCOOR,1),myctr(iCOOR,2),num2str(iCOOR))
    end
    
    [hE,hV]=wgPlot(AdjPos,myctr,'edgecolormap',summer(64),'vertexmarker','o');    
    axis image
    
    %% plot correlation as a function of distance
    D = squareform(pdist(myctr));
    kPairsIdx = sub2ind(size(D),kpairs(:,1),kpairs(:,2));
    kPairsDist = D(kPairsIdx);
    kPairsCorrcoef = R(kPairsIdx);
    
    % figure
    set(gca,'linewidth',2,'FontSize',24)
    clf
    posCorrIdx = kPairsCorrcoef>0;
    negCorrIdx = kPairsCorrcoef<0;
    Xpos = kPairsDist(posCorrIdx);
    Ypos = kPairsCorrcoef(posCorrIdx);
    hold on
    % plot(Xpos,Ypos,'ro','markerfacecolor',[0.9 0.6 0.6 ],'markersize',12)
    % AG comented
    if Xpos>2 & Ypos>2
        brobPos = robustfit(Xpos,Ypos);   %compute the equasion of regression line
        %plot(Xpos,brobPos(1)+brobPos(2)*Xpos,'r-','linewidth',3)% AG comented
    end
    Xneg = kPairsDist(negCorrIdx);
    Yneg = kPairsCorrcoef(negCorrIdx);
    %plot(Xneg,Yneg,'ko','markerfacecolor',[0.6 0.6 0.6],'markersize',12)% AG comented
    if Xneg>2 & Yneg>2
        brobNeg = robustfit(Xneg,Yneg);
        %plot(Xneg,brobNeg(1)+brobNeg(2)*Xneg,'k-','linewidth',3)% AG comented
    end
    %xlabel('Distance','FontSize',22)  %AG commneted
    %ylabel('Correlation Coeff','FontSize',22)
   
    %% compute significance  AG commneted 
    % compute significance by "shifting" 100 times the traces and recomputing
    %this used the SHIFT algorithm of Louie and Wilson 2001:
    %
    % Entire spike train vectors are temporally shifted relative to original alignment,
    % with relative temporal order preserved within each spike train. The shift distance
    % is pseudorandomly chosen and ranges between half the window length backward and
    % half the window length forward. The shift is circular, such that data removed from
    % the pattern at one end is reinserted at the opposite end.
    
    if prmts.doComputeSHIFT
        kpairs = nchoosek(1:nCells,2);% n!/((n–k)! k!). This is the number of combinations of n items taken k at a time.
        nPairs = size(kpairs,1);
        nSim = 1000;
        Psim = zeros(nPairs,1);
        parfor iPair = 1 : nPairs
            for iITER = 1 : nSim
                v1 = circshift(dF(kpairs(iPair,1),:),[1 -randi(nT/2)]);%shift backwards
                v2 = circshift(dF(kpairs(iPair,2),:),[1 randi(nT/2)]);%shift forward
                rsim = corrcoef(v1,v2);
                Psim(iPair) = Psim(iPair) + double(rsim(2)<R(kpairs(iPair,1),kpairs(iPair,1)));
            end %iter
        end %pairs
        Psim = Psim/nSim;
    end
    %% SVD analysis on matrix  (plot eigenval of 10 first eigvectors)
    
    if prmts.doComputeSVD
        [U,S,V] = eig(R);
        figure
        plot(diag(S))
        xlabel('Eigenvector')
        ylabel('Eigenvalue')
    end
    
     %s
    thisEXP.D = D;  %ag uncommneted till here
    
else %relates to the if for a case there's no data
Xpos=NaN;Ypos=NaN;Xneg=NaN;Yneg=NaN;    
    
end