close all;
clearvars;
clc;

mfilename('fullpath')
curPath = fileparts(mfilename('fullpath'));
rmpath(genpath(curPath));
addpath(genpath(curPath));
cd(curPath);

warning on
globalresult = [];
blPlot = false;
blSavePlot= false;
blUWBnoise = false;

% for i = 1:10
    % results = CompareSolvers(@executeLarssonTrilateration, 'Larsson',@executeFabertMultiLateration2,'Faber2',blPlot,blSavePlot,blUWBnoise);
    % results = CompareSolvers(@executeLarssonTrilateration,'Larsson',@executeFabertMultiLateration2a,'Faber2a',blPlot,blSavePlot,blUWBnoise);
    results = CompareSolvers(@executeLarssonTrilateration,'Larsson',@executeFabertMultiLateration2b,'Faber2b',blPlot,blSavePlot,blUWBnoise);
%     results = CompareSolvers(@executeLarssonTrilateration,'Larsson',@executeFabertMultiLateration9,'Faber9',blPlot,blSavePlot,blUWBnoise);
    
%     globalresult = [globalresult; round(sum(results.error.DiffDisSqr1),1) round(sum(results.error.DiffDisSqr2),1)]
% end

figure
bar([results.error.DiffDisSqr1; results.error.DiffDisSqr2]');
legend(results.name1,results.name2,'Location','best')
title(['Sum error ' results.name1 ': ' num2str(round(sum(results.error.DiffDisSqr1),1)) ', ' ...
    'Sum error ' results.name2 ': ' num2str(round(sum(results.error.DiffDisSqr2),1))]);
ylabel('Error')
xlabel('Different Anchor set ups'); grid on; grid minor;

figure
pdif = ProcentualDifference(results.error.DiffDisSqr1,results.error.DiffDisSqr2);
bar(pdif);
title(['Sum error: ' num2str(round(sum(pdif),1)) ', mean error: ' num2str(round(mean(pdif),1))]);
ylabel('Procentual Error')
xlabel('Different Anchor set ups'); grid on; grid minor;

% figure
% bar([results.duration.noise1; results.duration.noise2]');
% legend(results.name1,results.name2,'Location','best')
% title(['Duration ' results.name1 ': ' num2str(sum(results.duration.noise1)) ', ' ...
%     'Duration ' results.name2 ': ' num2str(sum(results.duration.noise2))]);
% ylabel('Duration')
% xlabel('Different Anchor set ups');
%% process results

