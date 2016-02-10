clear all
setpath
cttStr={ '0.08', '0.16','0.32','0.48'};
meshStr={'1x2','2x4','4x8','8x16'};
meshSize=[1,0.5,0.25,0.125]';
freqs=AnalyticalRectangularModalCavity(1);
iComp=6;

nCtt=1;
iCtt=1;
nMeshes=1;
p=2;
nFreqs=length(freqs);

[~,~] = mkdir('plotDtDependence');

for iMesh=1:nMeshes
    fprintf('loading....');
    load('4x8_p2_TM_uPoint.1.mat');
    fprintf('DONE\n');
    uPointDataList{iMesh,iCtt} = uPointData;
end

dts=round(linspace(50,100,1000));
for iMesh=1:nMeshes
    for iFreq=1:nFreqs
        for iDt=1:length(dts)
            fprintf('iDt=%d\n',iDt)
            dtSkip=dts(iDt);
            uPointDataTmp.uPoint = uPointDataList{iMesh,iCtt}.uPoint(dtSkip:dtSkip:end,:);
            uPointDataTmp.time = uPointDataList{iMesh,iCtt}.time(dtSkip:dtSkip:end);
            
            uPointDataTmp.dt = uPointDataTmp.time(2)-uPointDataTmp.time(1);
            [uPointDataTmp.nOfTimeSteps,uPointDataTmp.nOfComponents]=size(uPointDataTmp.uPoint);
            
            spectrum = getFFTSpectum(uPointDataTmp,'components',iComp);
            fittedPeaks = fitFFTSpectrumPeaks(spectrum,freqs(iFreq));
            finalError(iMesh,iDt)=fittedPeaks{1,1}.error;
            finalDt(iMesh,iDt)=uPointDataTmp.dt;
        end
        
        plot(finalDt(iMesh,:),log10(finalError(iMesh,:)),'LineWidth',4)
        hold on
    end
    xlabel('\Delta t','FontSize',40)
    ylabel('log_{10}(Error)','FontSize',40)
    xlim([min(finalDt),max(finalDt)])
    plot([2,2],[-8,-1],'--')
end
