function UKF_plotXYofWMPM_UWB_OPTITRACK()
close all; clc;
[ap.thisFile, nm.CurrFile] = fileparts(mfilename('fullpath'));
cd(ap.thisFile)

nameOfdir = 'synced';
apsynced = findSubFolderPath(ap.thisFile,'MATLAB',nameOfdir);

if not(exist(apsynced,'dir'))
    error([newline mfilename ': ' newline 'Folder "' nameOfdir '" does not exist!' newline]);
end
addpath(genpath(apsynced))

cd(apsynced);
files = makeFullPathFromDirOutput(dir('*.mat'));
cd(ap.thisFile)

for nF = 1:length(files)
    ap.measurement = files(nF).fullpath;
    load(ap.measurement);
    
    UKF = plotTheSystems(opti,uwb,wmpm,ap,sOpti,files(nF));

    
    plotOptitrackAndUWB(opti,uwb,wmpm,ap,sOpti);
    exportgraphics(gcf,replace(files(nF).name,'.mat','_uwbopti.png'),'BackgroundColor','none');
    
    plotOptitrackAndUKF(opti,uwb,wmpm,UKF,ap,sOpti);
    exportgraphics(gcf,replace(files(nF).name,'.mat','_opti_UKF.png'),'BackgroundColor','none');
    close all;
end
end


function UKF_OUT = plotTheSystems(opti,uwb,wmpm,ap,sOpti,files)

figure('units','normalized','outerposition',[0.1 0.1 0.9 0.9]);
optiClean = opti.cleanSignalTimeIdx(1):opti.cleanSignalTimeIdx(2);
% plot(opti.coord.x(optiClean), opti.coord.y(optiClean),'g'); hold on;
optiClean = optiClean + opti.syncPoints(2);
scatter(opti.notfilled.x(optiClean-1),opti.notfilled.y(optiClean-1),'g.');
hold on;
plotMarkerStartAndfinish(opti);
title('Optitrack coordinates');

wmpmClean = wmpm.cleanSignalTimeIdx(1):wmpm.cleanSignalTimeIdx(2);
xlimvals = [min(wmpm.coord.x(wmpmClean)) max(wmpm.coord.x(wmpmClean))];
ylimvals = [min(wmpm.coord.y(wmpmClean)) max(wmpm.coord.y(wmpmClean))];
xlimvals = [min(min(xlimvals), min(opti.notfilled.x(optiClean-1))) max(max(xlimvals), max(opti.notfilled.x(optiClean-1)))]*1.15;
ylimvals = [min(min(ylimvals), min(opti.notfilled.y(optiClean-1))) max(max(ylimvals), max(opti.notfilled.y(optiClean-1)))]*1.15;

setupPlot(xlimvals,ylimvals);
exportgraphics(gcf,replace(files.name,'.mat','_1.png'),'BackgroundColor','none'); close all;


figure('units','normalized','outerposition',[0.1 0.1 0.9 0.9]);
wmpmClean = wmpm.cleanSignalTimeIdx(1):wmpm.cleanSignalTimeIdx(2);
plot(wmpm.coord.x(wmpmClean),wmpm.coord.y(wmpmClean),'b'); hold on;
% plot(wmpm.coord.x - offsetWMPM(1),wmpm.coord.y - offsetWMPM(2),'r');
plotMarkerStartAndfinish(wmpm)
title('WMPM Coordinates');
setupPlot(xlimvals,ylimvals);
exportgraphics(gcf,replace(files.name,'.mat','_2.png'),'BackgroundColor','none'); close all;


figure('units','normalized','outerposition',[0.1 0.1 0.9 0.9]);
uwbClean = uwb.cleanSignalTimeIdx(1):uwb.cleanSignalTimeIdx(2);
plot(uwb.coord.x(uwbClean), uwb.coord.y(uwbClean),'r'); hold on;
plotMarkerStartAndfinish(uwb)
title('UWB Coordinates');
setupPlot(xlimvals,ylimvals)
exportgraphics(gcf,replace(files.name,'.mat','_3.png'),'BackgroundColor','none'); close all;


figure('units','normalized','outerposition',[0.1 0.1 0.9 0.9]);
UKF_OUT = UKF_main_nonlinear(ap.measurement);
plot(UKF_OUT(:,1), UKF_OUT(:,2),'m'); hold on;
plotMarkerStartAndfinish(UKF_OUT,[UKF_OUT(1,1) UKF_OUT(1,2)],[UKF_OUT(end,1) UKF_OUT(end,2)])
title('UKF Coordinates');
setupPlot(xlimvals,ylimvals)
exportgraphics(gcf,replace(files.name,'.mat','_4.png'),'BackgroundColor','none'); close all;
end


function setupPlot(xlimvals,ylimvals, blLegend)
xlabel('x-coordinates [mm]'); ylabel('y-coordinates [mm]');
grid on; grid minor; box on; axis equal; box on;
set(findall(0,'type','line'),'linewidth',2);
if exist('blLegend','var') && not(isempty(blLegend))
    legend
end
if exist('xlimvals','var') && not(isempty(xlimvals))
    ylim(ylimvals); xlim(xlimvals);
end
end


function plotOptitrackAndUWB(opti,uwb,wmpm,ap,sOpti)
figure('units','normalized','outerposition',[0.1 0.1 0.9 0.9]);

optiClean = opti.cleanSignalTimeIdx(1):opti.cleanSignalTimeIdx(2);
% plot(opti.coord.x(optiClean), opti.coord.y(optiClean),'g','DisplayName','Optitrack coordinates'); hold on;

optiClean = optiClean + opti.syncPoints(2);
scatter(opti.notfilled.x(optiClean-1),opti.notfilled.y(optiClean-1),'g.','DisplayName','Optitrack coordinates'); hold on;

uwbClean = uwb.cleanSignalTimeIdx(1):uwb.cleanSignalTimeIdx(2);
plot(uwb.coord.x(uwbClean), uwb.coord.y(uwbClean),'r','DisplayName', 'UWB coordinates');

title('Optitrack and UWB coordinates');
setupPlot([],[], 1);

xlim([min(uwb.coord.x) max(uwb.coord.x)]*1.05);
ylim([min(uwb.coord.y) max(uwb.coord.y)]*1.05);
end


function plotOptitrackAndUKF(opti,uwb,wmpm,ukf,ap,sOpti)
figure('units','normalized','outerposition',[0.1 0.1 0.9 0.9]);

optiClean = opti.cleanSignalTimeIdx(1):opti.cleanSignalTimeIdx(2);
% plot(opti.coord.x(optiClean), opti.coord.y(optiClean),'g','DisplayName','Optitrack coordinates'); hold on;
optiClean = optiClean + opti.syncPoints(2);
scatter(opti.notfilled.x(optiClean-1),opti.notfilled.y(optiClean-1),'g.','DisplayName','Optitrack coordinates'); hold on;

plot(ukf(:,1),ukf(:,2), 'm','DisplayName', 'UKF');
xlabel('x-coordinates [mm]');
ylabel('y-coordinates [mm]');
axis equal

title('UKF coordinates vs. Optitrack');
setupPlot([],[], 1);

xlim([min(ukf(:,1)) max(ukf(:,1))]*1.05);
ylim([min(ukf(:,2)) max(ukf(:,2))]*1.05);
end


function plotMarkerStartAndfinish(data,start,finished)
if not(exist('start','var')) && not(exist('finished','var'))
    hold on;
    cleanIdxStart = data.cleanSignalTimeIdx(1); cleanIdxEnd = data.cleanSignalTimeIdx(2);
    plot(data.coord.x(cleanIdxStart),data.coord.y(cleanIdxStart),'ok','LineWidth',2,'MarkerSize',9,'DisplayName','start');
    plot(data.coord.x(cleanIdxEnd),data.coord.y(cleanIdxEnd),'xk','LineWidth',2,'MarkerSize',9,'DisplayName','end');
else
    hold on;
    plot(start(1),start(2),'ok','LineWidth',2,'MarkerSize',9,'DisplayName','start');
    plot(finished(1),finished(2),'xk','LineWidth',2,'MarkerSize',9,'DisplayName','end');
end
end


function offsetWMPM = getOffsetToMakeWMPMStartAtUWBlocation(uwb,wmpm)
offsetWMPM = [wmpm.coord.x(1)-uwb.coord.x(1) wmpm.coord.y(1)-uwb.coord.y(1)];
end