function [results] = CompareSolversRun(varargin)
% alg1,alg2,numAnchors,blPlot,blSavePlot,blUWBnoise,blPlotClean,blDuration
close all;
clc;

%% Parse varargin
% Test for right input
minargin = 3;
maxargin = (minargin+5)*2;
if nargin < minargin
    error([ mfilename ':Needs at minimum' num2str(minargin) ' argument(s) ']);
end
if nargin > maxargin
    error([ mfilename ':Needs max ' num2str(minargin) ' arguments ']);
end

if nargin > 1
    % Create variables that need to be filled
    blPlot = false;
    blSavePlot = false;
    blUWBnoise = false;
    blPlotClean = false;
    blDuration = false;
    blShowFinPlot = false;
    
    % fill some variables
    alg1 = varargin{1};
    alg2 = varargin{2};
    numAnchors = varargin{3};
    
    % parse the others
    for narg = 4:nargin
        try
            sc = lower(varargin{narg});
            switch sc
                case {'saveplot'}
                    blSavePlot = true;
                case {'plot'}
                    blPlot = true;
                case {'uwbnoise'}
                    blUWBnoise = true;
                case {'plotclean'}
                    blSavePlot = true;
                case {'finplot'}
                    blShowFinPlot = true;
                case {'duration'}
                    blDuration = true;
                otherwise
                    % Do nothing in the case of varargin{narg+1};
            end
        catch
        end
    end
end

%% ADMINISTRATION
mfilename('fullpath');
curPath = fileparts(mfilename('fullpath'));
apHelper = fullfile(extractBefore(curPath,'SIMULATION'),'SIMULATION','helper');
rmpath(genpath(curPath));
addpath(genpath(curPath));
rmpath(genpath(apHelper));
addpath(genpath(apHelper));
cd(curPath);
apOutput = [ '.' filesep 'output' filesep];

warning on
stat.numanchors = numAnchors;
stat.strnumanchors = num2str(stat.numanchors);
xlab = 'Anchors-Tag setups';

if blUWBnoise
    stat.noisetype = 'UWB noise';
else
    stat.noisetype = 'Gaussian noise';
end

% Ensure capital letter at beginning
Alg1 = [upper(alg1(1)) lower(alg1(2:end))];
Alg2 = [upper(alg2(1)) lower(alg2(2:end))];

results = CompareSolvers(getHandleSolver(Alg1),Alg1,getHandleSolver(Alg2),Alg2,...
    blPlot,blSavePlot,blUWBnoise,blPlotClean,blDuration);

stat.infostr.plot = [results.name1 ' compared to ' results.name2 ', ' stat.strnumanchors ' Anchors, ' stat.noisetype ];
stat.infostr.file = replace(stat.infostr.plot,' ','_');
stat.infostr.file = replace(stat.infostr.file,',','_');
stat.infostr.file = replace(stat.infostr.file,'__','_');

%% Distances (simulation)
if not(blDuration)
    createErrorPlots(results.error.fun1.Dist.noise,results.error.fun2.Dist.noise,'noise');
    createErrorPlots(results.error.fun1.Dist.clean,results.error.fun2.Dist.clean,'clean');
else
    %% Duration
    createDurationPlots(results.fun1.duration.noise,results.fun2.duration.noise,'noise');
    createDurationPlots(results.fun1.duration.clean,results.fun2.duration.clean,'clean');
end

    function createErrorPlots(pos1,pos2,extratxt)
        if not(exist('extratxt','var'))
            extratxt = '';
        end
        figureCompareSolvers;
        bar([[pos1{:}]; [pos2{:}]]')
        legend(results.name1,results.name2,'Location','best')
        title(['Sum distance errors ' results.name1 ': ' num2str(round(sum([pos1{:}]),1)) ', ' ...
            results.name2 ': ' num2str(round(sum([pos2{:}]),1))]);
        ylabel('Error')
        xlabel(xlab); grid on; grid minor;
        saveas(gcf,[apOutput stat.infostr.file '_Distance_' extratxt '.png']);
        
        figureCompareSolvers;
        pdif = PercentageChange([pos1{:}],[pos2{:}]);
        bar(pdif);
        title([stat.infostr.plot ' (\mu = ' num2str(round(mean(pdif),1)) ')'],'Interpreter','tex');
        xlabel(xlab); grid on; grid minor;
        ylabel('%');
        saveas(gcf,[apOutput stat.infostr.file '_Distance_' extratxt '_P.png']);
    end



    function createDurationPlots(pos1,pos2,extratxt)
        if not(exist('extratxt','var'))
            extratxt = '';
        end
        figureCompareSolvers;
        bar([[pos1{:}]; [pos2{:}]]')
        legend(results.name1,results.name2,'Location','best')
        title(['Duration ' results.name1 ': ' num2str(round(sum([pos1{:}]),1)) ', ' ...
            results.name2 ': ' num2str(round(sum([pos2{:}]),1))]);
        ylabel('Duration [seconds]')
        xlabel(xlab); grid on; grid minor;
        saveas(gcf,[apOutput stat.infostr.file '_Duration_' extratxt '.png']);
        
        figureCompareSolvers;
        pdif = PercentageChange([pos1{:}],[pos2{:}]);
        bar(pdif);
        title(['Duration ' stat.infostr.plot ' (\mu = ' num2str(round(mean(pdif),1)) ')'],'Interpreter','tex');
        xlabel(xlab); grid on; grid minor;
        ylabel('%');
        saveas(gcf,[apOutput stat.infostr.file '_Duration_' extratxt '_P.png']);
    end

    function figureCompareSolvers()
        if blShowFinPlot
            figure('Position',[400 400 800 600],'Visible','on');
        else
            figure('Position',[400 400 800 600],'Visible','off');
        end
    end

    function handle = getHandleSolver(name)
        switch lower(name)
            case 'vinay'
                handle = @executeVinay1;
            case 'larsson'
                handle = @executeLarssonTrilateration;
            case 'faber2a'
                handle = @executeFabertMultiLateration2a;
            case 'faber2b'
                handle = @executeFabertMultiLateration2b;
            case  'faber9'
                handle = @executeFabertMultiLateration9;
            case 'murphy'
                handle = @executeMurphy1;
            otherwise
                error([newline mfilename ': ' newline 'Can not happen!' newline]);
        end
    end
end


%% Positional (practical)
% figureCompareSolvers;
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