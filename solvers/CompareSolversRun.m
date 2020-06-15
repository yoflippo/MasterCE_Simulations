close all;
clearvars;
clc;

mfilename('fullpath')
curPath = fileparts(mfilename('fullpath'));
apHelper = fullfile(extractBefore(curPath,'SIMULATION'),'SIMULATION','helper');
rmpath(genpath(curPath));
addpath(genpath(curPath));
rmpath(genpath(apHelper));
addpath(genpath(apHelper));
cd(curPath);

%% NEED TO ADD HELPER


warning on
globalresult = [];
blPlot = false;
blPlotClean = false;
blSavePlot= false;
blUWBnoise = true;

% results = CompareSolvers(@executeLarssonTrilateration, 'Larsson',@executeFabertMultiLateration2,'Faber2',blPlot,blSavePlot,blUWBnoise,blPlotClean);
% results = CompareSolvers(@executeLarssonTrilateration,'Larsson',@executeFabertMultiLateration2a,'Faber2a',blPlot,blSavePlot,blUWBnoise,blPlotClean);
% results = CompareSolvers(@executeLarssonTrilateration,'Larsson',@executeFabertMultiLateration2b,'Faber2b',blPlot,blSavePlot,blUWBnoise,blPlotClean);
% results = CompareSolvers(@executeLarssonTrilateration,'Larsson',@executeFabertMultiLateration9,'Faber9',blPlot,blSavePlot,blUWBnoise,blPlotClean);

results = CompareSolvers(@executeLarssonTrilateration,'Larsson',@executeVinay1,'Vinay',blPlot,blSavePlot,blUWBnoise,blPlotClean);

%% Distances (simulation)
% figure
% bar([[results.error.fun1.Dist.noise{:}]; [results.error.fun2.Dist.noise{:}]]')
% legend(results.name1,results.name2,'Location','best')
% title(['Sum distance errors ' results.name1 ': ' num2str(round(sum([results.error.fun1.Dist.noise{:}]),1)) ', ' ...
%     results.name2 ': ' num2str(round(sum([results.error.fun2.Dist.noise{:}]),1))]);
% ylabel('Error')
% xlabel('Different setups'); grid on; grid minor;

figure
pdif = PercentageChange([results.error.fun1.Dist.noise{:}],[results.error.fun2.Dist.noise{:}]);
bar(pdif);
title(['Sum error: ' num2str(round(sum(pdif),1)) ', mean error: ' num2str(round(mean(pdif),1))]);
ylabel('Procentual Error')
xlabel('Different setups'); grid on; grid minor;

%% Positional (practical)
% figure
% bar([[results.error.fun1.Pos.noise{:}]; [results.error.fun2.Pos.noise{:}]]')
% legend(results.name1,results.name2,'Location','best')
% title(['Sum positional errors ' results.name1 ': ' num2str(round(sum([results.error.fun1.Pos.noise{:}]),1)) ', ' ...
%      results.name2 ': ' num2str(round(sum([results.error.fun2.Pos.noise{:}]),1))]);
% ylabel('Error')
% xlabel('Simulations'); grid on; grid minor;

figure
pdif = PercentageChange([results.error.fun1.Pos.noise{:}],[results.error.fun2.Pos.noise{:}]);
bar(pdif);
title(['Sum error: ' num2str(round(sum(pdif),1)) ', mean error: ' num2str(round(mean(pdif),1))]);
ylabel('Procentual Error')
xlabel('Simulations'); grid on; grid minor;

% %% Duration
% figure
% bar([[results.fun1.duration.noise{:}]; [results.fun1.duration.noise{:}]]')
% legend(results.name1,results.name2,'Location','best')
% title(['Duration ' results.name1 ': ' num2str(round(sum([results.error.fun1.Pos.noise{:}]),1)) ', ' ...
%      results.name2 ': ' num2str(round(sum([results.error.fun2.Pos.noise{:}]),1))]);
% ylabel('Error')
% xlabel('Simulations'); grid on; grid minor;
% 
% figure
% pdif = ProcentualDifference([results.fun1.duration.noise{:}],[results.fun1.duration.noise{:}]);
% bar(pdif);
% title(['Duration: ' num2str(round(sum(pdif),1)) ', mean error: ' num2str(round(mean(pdif),1))]);
% ylabel('Procentual Error')
% xlabel('Simulations'); grid on; grid minor;




