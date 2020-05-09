%% Test Fabert
close all;
clearvars; clc;

mfilename('fullpath')
curPath = fileparts(mfilename('fullpath'));
rmpath(genpath(curPath));
addpath(genpath(curPath));
cd(curPath);
cd ..

% Find .mat files with dummy data
matfiles = dir(['**' filesep '*.mat']);
matfiles(~contains({matfiles.name},'uwb'))=[];
load(matfiles(1).name);

% Give number of dummy data files you want to use
numberOfPlotsToOpen = 30;
if numberOfPlotsToOpen >  length(matfiles)
    numberOfPlotsToOpen = length(matfiles);
end

sumError = 0;
fabfun = @executeFabertMultiLateration; % create function handle

%% Plot Results
for i = 1:numberOfPlotsToOpen
    fn = matfiles(i).name;
    load(fn);
    
    res.clean = fabfun(data);
    plotSolver(fn,res.clean,'g','o','Faber Clean')
    title('Clean data');
    
    % UWB noise due to larger distance
    data.Distances = createUWBNoise(data.Distances,5);
    
    res.noise = fabfun(data);
    plotSolver(fn,res.noise,'r','o','Faber Clean')
    title(['Error_{clean} is ' getCalculatedErrorString(data.TagPositions,res.clean) ...
        '                   Error_{noise} is ' getCalculatedErrorString(data.TagPositions,res.noise)],'Interpreter','tex');
    f=get(gca,'Children');
    legend([f(or(contains({f.DisplayName},'Faber'),contains({f.DisplayName},'Larsson')))],'Location','best')
    
    [~, sE] = getCalculatedErrorString(data.TagPositions,res.noise);
    if ~isnan(sE)
        sumError = sumError + sE;
    end
end
sumError
distFig('Tight',true)
