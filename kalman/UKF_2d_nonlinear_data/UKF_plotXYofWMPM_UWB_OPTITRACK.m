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
    
    UKF = plotTheSystems(opti,uwb,wmpm,ap);
    saveTightFigure(gcf,replace(files(nF).name,'.mat','.png'));
    
    plotOptitrackAndUWB(opti,uwb,wmpm,ap)
    saveTightFigure(gcf,replace(files(nF).name,'.mat','_uwbopti.png'));
    
    plotOptitrackAndUKF(opti,uwb,wmpm,UKF,ap)
    saveTightFigure(gcf,replace(files(nF).name,'.mat','_opti_UKF.png'));
    close all;
end
end


function UKF_OUT = plotTheSystems(opti,uwb,wmpm,ap)
figure('units','normalized','outerposition',[0.1 0.1 0.9 0.9]);

subplot(2,2,1);
optiClean = opti.cleanSignalTimeIdx(1):opti.cleanSignalTimeIdx(2);
plot(opti.coord.x(optiClean), opti.coord.y(optiClean),'g');
plotMarkerStartAndfinish(opti)
xlabel('x-coordinates'); ylabel('y-coordinates');
title('Optitrack coordinates');
axis equal
xlimvals = get(gca,'XLim')*1.05;
ylimvals = get(gca,'YLim')*1.05;
grid on; grid minor;

offsetWMPM = getOffsetToMakeWMPMStartAtUWBlocation(uwb,wmpm);

subplot(2,2,2);
wmpmClean = wmpm.cleanSignalTimeIdx(1):wmpm.cleanSignalTimeIdx(2);
plot(wmpm.coord.x(wmpmClean),wmpm.coord.y(wmpmClean),'b');
hold on;
% plot(wmpm.coord.x - offsetWMPM(1),wmpm.coord.y - offsetWMPM(2),'r');
plotMarkerStartAndfinish(wmpm)
xlabel('x-coordinates'); ylabel('y-coordinates');
title('WMPM Coordinates');
grid on; grid minor;
axis equal
ylim(ylimvals); xlim(xlimvals);

subplot(2,2,3);
uwbClean = uwb.cleanSignalTimeIdx(1):uwb.cleanSignalTimeIdx(2);
plot(uwb.coord.x(uwbClean), uwb.coord.y(uwbClean),'r');
plotMarkerStartAndfinish(uwb)
xlabel('x-coordinates'); ylabel('y-coordinates');
title('UWB Coordinates');
grid on; grid minor;
axis equal
ylim(ylimvals); xlim(xlimvals);
set(findall(0,'type','line'),'linewidth',2);

subplot(2,2,4);
UKF_OUT = UKF_main_nonlinear(ap.measurement);
plot(UKF_OUT(:,1), UKF_OUT(:,2),'m');
plotMarkerStartAndfinish(UKF_OUT,[UKF_OUT(1,1) UKF_OUT(1,2)],[UKF_OUT(end,1) UKF_OUT(end,2)])
xlabel('x-coordinates'); ylabel('y-coordinates');
title('UKF Coordinates');
grid on; grid minor;
axis equal
ylim(ylimvals); xlim(xlimvals);
set(findall(0,'type','line'),'linewidth',2);
end


function plotOptitrackAndUWB(opti,uwb,wmpm,ap)
figure('units','normalized','outerposition',[0.1 0.1 0.9 0.9]);

optiClean = opti.cleanSignalTimeIdx(1):opti.cleanSignalTimeIdx(2);
plot(opti.coord.x(optiClean), opti.coord.y(optiClean),'g','DisplayName','Optitrack coordinates'); hold on;

uwbClean = uwb.cleanSignalTimeIdx(1):uwb.cleanSignalTimeIdx(2);
plot(uwb.coord.x(uwbClean), uwb.coord.y(uwbClean),'r','DisplayName', 'UWB coordinates');
xlabel('x-coordinates');
ylabel('y-coordinates');
axis equal

xlim([min(uwb.coord.x) max(uwb.coord.x)]*1.05);
ylim([min(uwb.coord.y) max(uwb.coord.y)]*1.05);
title('Optitrack and UWB coordinates');
legend
grid on; grid minor;
set(findall(0,'type','line'),'linewidth',2);
end


function plotOptitrackAndUKF(opti,uwb,wmpm,ukf,ap)
figure('units','normalized','outerposition',[0.1 0.1 0.9 0.9]);

optiClean = opti.cleanSignalTimeIdx(1):opti.cleanSignalTimeIdx(2);
plot(opti.coord.x(optiClean), opti.coord.y(optiClean),'g','DisplayName','Optitrack coordinates'); hold on;

plot(ukf(:,1),ukf(:,2), 'm','DisplayName', 'UKF');
xlabel('x-coordinates');
ylabel('y-coordinates');
axis equal

xlim([min(ukf(:,1)) max(ukf(:,1))]*1.05);
ylim([min(ukf(:,2)) max(ukf(:,2))]*1.05);
title('UKF coordinates vs. Optitrack');
legend
grid on; grid minor;
set(findall(0,'type','line'),'linewidth',2);
end


function plotMarkerStartAndfinish(data,start,finished)
if not(exist('start','var')) && not(exist('finished','var'))
    hold on;
    cleanIdxStart = data.cleanSignalTimeIdx(1); cleanIdxEnd = data.cleanSignalTimeIdx(2);
    plot(data.coord.x(cleanIdxStart),data.coord.y(cleanIdxStart),'ok','LineWidth',2,'MarkerSize',9);
    plot(data.coord.x(cleanIdxEnd),data.coord.y(cleanIdxEnd),'xk','LineWidth',2,'MarkerSize',9);
else
    hold on;
    plot(start(1),start(2),'ok','LineWidth',2,'MarkerSize',9);
    plot(finished(1),finished(2),'xk','LineWidth',2,'MarkerSize',9);
end
end


function offsetWMPM = getOffsetToMakeWMPMStartAtUWBlocation(uwb,wmpm)
offsetWMPM = [wmpm.coord.x(1)-uwb.coord.x(1) wmpm.coord.y(1)-uwb.coord.y(1)];
end