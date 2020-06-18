function CompareSolversRun(alg1,alg2,numAnchors,blPlot,blSavePlot,blUWBnoise,blPlotClean,blDuration)
if ~exist('blPlot','var')
    blPlot = false;
end
if ~exist('blSavePlot','var')
    blSavePlot = false;
end
if ~exist('blUWBnoise','var')
    blUWBnoise = false;
end
if ~exist('blPlotClean','var')
    blPlotClean = false;
end
if ~exist('blDuration','var')
    blDuration = false;
end
close all;
clc;

mfilename('fullpath')
curPath = fileparts(mfilename('fullpath'));
apHelper = fullfile(extractBefore(curPath,'SIMULATION'),'SIMULATION','helper');
rmpath(genpath(curPath));
addpath(genpath(curPath));
rmpath(genpath(apHelper));
addpath(genpath(apHelper));
cd(curPath);
apOutput = [ '.' filesep 'output' filesep];

warning on
globalresult = [];
stat.numanchors = numAnchors;
stat.strnumanchors = num2str(stat.numanchors);

xlab = 'Anchors-Tag setups';

blPlot = false;
blPlotClean = false;
blSavePlot= false;
blUWBnoise = false;
blDuration = false;
if blUWBnoise
    stat.noisetype = 'UWB noise';
else
    stat.noisetype = 'Gaussian noise';
end



concatmethods = lower([alg1 alg2]);
switch concatmethods
    case 'larssonvinay'
        results = CompareSolvers(@executeLarssonTrilateration,'Larsson',@executeVinay1,...
            'Vinay',blPlot,blSavePlot,blUWBnoise,blPlotClean,blDuration);
    case 'larssonfaber2'
        results = CompareSolvers(@executeLarssonTrilateration, 'Larsson',@executeFabertMultiLateration2,...
            'Faber2',blPlot,blSavePlot,blUWBnoise,blPlotClean,blDuration);
    case 'larssonfaber2a'
        results = CompareSolvers(@executeLarssonTrilateration,'Larsson',@executeFabertMultiLateration2a,....
            'Faber2a',blPlot,blSavePlot,blUWBnoise,blPlotClean,blDuration);
    case 'larssonfaber2b'
        results = CompareSolvers(@executeLarssonTrilateration,'Larsson',@executeFabertMultiLateration2b,...
            'Faber2b',blPlot,blSavePlot,blUWBnoise,blPlotClean,blDuration);
    case  'larssonfaber9'
        results = CompareSolvers(@executeLarssonTrilateration,'Larsson',@executeFabertMultiLateration9,...
            'Faber9',blPlot,blSavePlot,blUWBnoise,blPlotClean,blDuration);
    case 'faber2avinay'
        results = CompareSolvers(@executeFabertMultiLateration2a,'Faber2a',...
            @executeVinay1,'Vinay',blPlot,blSavePlot,blUWBnoise,blPlotClean,blDuration);
    otherwise
        disp([mfilename ': NOTHING TO DO, did not found combination ' concatmethods]);
end

stat.infostr.plot = [results.name1 ' compared to ' results.name2 ', ' stat.strnumanchors ' Anchors, ' stat.noisetype ];
stat.infostr.file = replace(stat.infostr.plot,' ','_');
stat.infostr.file = replace(stat.infostr.file,',','_');
stat.infostr.file = replace(stat.infostr.file,'__','_');

%% Distances (simulation)
if not(blDuration)
    figure('Position',[400 400 800 600])
    bar([[results.error.fun1.Dist.noise{:}]; [results.error.fun2.Dist.noise{:}]]')
    legend(results.name1,results.name2,'Location','best')
    title(['Sum distance errors ' results.name1 ': ' num2str(round(sum([results.error.fun1.Dist.noise{:}]),1)) ', ' ...
        results.name2 ': ' num2str(round(sum([results.error.fun2.Dist.noise{:}]),1))]);
    ylabel('Error')
    xlabel(xlab); grid on; grid minor;
    saveas(gcf,[apOutput stat.infostr.file '_DistanceNoise.png']);
    
    figure('Position',[400 400 800 600])
    pdif = PercentageChange([results.error.fun1.Dist.noise{:}],[results.error.fun2.Dist.noise{:}]);
    bar(pdif);
    title([stat.infostr.plot ' (\mu = ' num2str(round(mean(pdif),1)) ')'],'Interpreter','tex');
    xlabel(xlab); grid on; grid minor;
    ylabel('%');
    saveas(gcf,[apOutput stat.infostr.file '_DistanceNoise_P.png']);
    
    
    %% Positional (practical)
    % figure('Position',[400 400 800 600])
    % bar([[results.error.fun1.Pos.noise{:}]; [results.error.fun2.Pos.noise{:}]]')
    % legend(results.name1,results.name2,'Location','best')
    % title(['Sum positional errors ' results.name1 ': ' num2str(round(sum([results.error.fun1.Pos.noise{:}]),1)) ', ' ...
    %      results.name2 ': ' num2str(round(sum([results.error.fun2.Pos.noise{:}]),1))]);
    % ylabel('Error')
    %     xlabel(xlab); grid on; grid minor;
    
    %     figure('Position',[400 400 800 600])
    %     pdif = PercentageChange([results.error.fun1.Pos.noise{:}],[results.error.fun2.Pos.noise{:}]);
    %     bar(pdif);
    %     title([stat.infostr.plot ' (\mu = ' num2str(round(mean(pdif),1)) ')'],'Interpreter','tex');
    %     xlabel(xlab); grid on; grid minor;
    %     ylabel('%');
    %     saveas(gcf,[apOutput stat.infostr.file '_Position_P.png']);
else
    %% Duration
    figure('Position',[400 400 800 600])
    bar([[results.fun1.duration.noise{:}]; [results.fun2.duration.noise{:}]]')
    legend(results.name1,results.name2,'Location','best')
    title(['Duration ' results.name1 ': ' num2str(round(sum([results.fun1.duration.noise{:}]),1)) ', ' ...
        results.name2 ': ' num2str(round(sum([results.fun2.duration.noise{:}]),1))]);
    ylabel('Duration [seconds]')
    xlabel(xlab); grid on; grid minor;
    saveas(gcf,[apOutput stat.infostr.file '_Position.png']);
    
    figure('Position',[400 400 800 600])
    pdif = PercentageChange([results.fun1.duration.noise{:}],[results.fun2.duration.noise{:}]);
    bar(pdif);
    title(['Duration ' stat.infostr.plot ' (\mu = ' num2str(round(mean(pdif),1)) ')'],'Interpreter','tex');
    xlabel(xlab); grid on; grid minor;
    ylabel('%');
    saveas(gcf,[apOutput stat.infostr.file '_Duration_P.png']);
end



end