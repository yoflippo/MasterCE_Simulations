function makeBoxPlotsOfDurationDifferentSolvers()
close all; clc;
apThisFile = fileparts(mfilename('fullpath'));
cd(apThisFile);

set(0,'defaultTextInterpreter','none'); 

ap.simulation = findSubFolderPath(pwd,'UWB','SIMULATION');
addpath(genpath(ap.simulation));
load('runallComparisonSingle_results_paperuwbnoise7ancsScaled2.mat');

durations = collectDurationsOfDifferentSolvers(results);
xlabelsWithDuration = getXLabelsWithDuration(durations);

titlePlot = 'Duration of trilateration for different solvers';
makeViolinPlotsOfDistances(durations,titlePlot,apThisFile,xlabelsWithDuration);
makeBoxPlotsOfDistances(durations,titlePlot,apThisFile,xlabelsWithDuration);
end


function xlabelsWithDuration = getXLabelsWithDuration(durations)
meantxt = num2str(round(mean(durations.larsson),3));
xlabelsWithDuration{2} = ['Larsson (\mu = ' meantxt ')'];
meantxt = num2str(round(mean(durations.murphy),3));
xlabelsWithDuration{1} = ['Murphy (\mu = ' meantxt ')'];
meantxt = num2str(round(mean(durations.faber),3));
xlabelsWithDuration{3} = ['Faber (\mu = ' meantxt ')'];
end


function durations = collectDurationsOfDifferentSolvers(results)
[r,c] = size(results);

larsson = [];
murphy = [];
faber = [];

durations = [];
for nC = 1:c
    larsson = [larsson [results(1,nC).duration.noise.uwb{:}]];
    murphy = [murphy [results(2,nC).duration.noise.uwb{:}]];
    faber = [faber [results(3,nC).duration.noise.uwb{:}]];
end

durations.larsson = larsson;
durations.murphy = murphy;
durations.faber = faber;
end


function makeViolinPlotsOfDistances(duration,titlePlot,apThisFile,xlabels)
figure('units','normalized','outerposition',[0.1 0.1 0.4 0.5],'Visible','on');

if not(exist('xlabels','var'))
    violinplot([duration.murphy' duration.larsson' duration.faber'], ...
        {'Murphy' 'Larsson' 'Faber'},'MedianColor',[1 0 0],'ShowMean',true);
else
    violinplot([duration.murphy' duration.larsson' duration.faber'], ...
        xlabels,'MedianColor',[1 0 0],'ShowMean',true);
end


grid on; grid minor; title(titlePlot);
ylabel('Duration to trilaterate sample set [s]');

axis tight
setFigureSpecs();
% ylim([0 300]);
oldPath = pwd;
cd(apThisFile);
saveTightFigure(gcf,['ViolinPlot_' replace(titlePlot,' ','_') '.png']);
cd(oldPath);
end


function makeBoxPlotsOfDistances(duration,titlePlot,apThisFile,xlabels)
figure('units','normalized','outerposition',[0.1 0.1 0.4 0.5],'Visible','on');

if not(exist('xlabels','var'))
    bh = boxplot([duration.murphy' duration.larsson' duration.faber'], ...
        {'Murphy' 'Larsson' 'Faber'},'Notch','on');
else
    bh = boxplot([duration.murphy' duration.larsson' duration.faber'], ...
        xlabels,'Notch','on');
end

hAx=gca; hAx.XAxis.TickLabelInterpreter='tex';
hAx.XAxis.Label.Interpreter = 'tex';

grid on; grid minor; title(titlePlot);
ylabel('Duration to trilaterate sample set [s]');

set(bh,'LineWidth', 1);
grid on; grid minor;

Fh = gcf;
Kids = Fh.Children;
setFont(findobj(Kids,'Type','Axes'),12)

% ylim([0 600]);

oldPath = pwd;
cd(apThisFile);
saveTightFigure(gcf,['BoxPlot_' replace(titlePlot,' ','_') '.png']);
cd(oldPath);
end


function setFont(ax,fontsize)
ax.FontSize = fontsize;
ax.XAxis.FontSize = fontsize;
ax.YAxis.FontSize = fontsize;

ax.XAxis.Label.FontSize = fontsize;
ax.YAxis.Label.FontSize = fontsize;

ax.YAxis.Label.FontWeight = 'bold';
ax.XAxis.Label.FontWeight = 'bold';
end


function setFigureSpecs(fontsize)
if not(exist('fontsize','var'))
    fontsize = 12;
end

Fh = gcf;
Kids = Fh.Children;

AxAll = findobj(Kids,'Type','Axes');
Ax1 = AxAll(1);
set(Ax1,'LineWidth',0.5)

setFont(Ax1,fontsize)
end
