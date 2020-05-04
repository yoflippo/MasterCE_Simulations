%% Fabert vs. Larsson .... FIGHT!
close all;
clearvars; clc;

mfilename('fullpath')
curPath = fileparts(mfilename('fullpath'));
rmpath(genpath(curPath));
addpath(genpath(curPath));
cd(curPath);

% Find .mat files with dummy data
matfiles = dir(['**' filesep '*.mat']);
matfiles(~contains({matfiles.name},'uwb'))=[];
load(matfiles(1).name);

% Give number of dummy data files you want to use
numberOfPlotsToOpen = 30;
if numberOfPlotsToOpen >  length(matfiles)
    numberOfPlotsToOpen = length(matfiles);2
end

durationLarsson = [];
durationFaber = [];
%% Plot Results
for i = 1:numberOfPlotsToOpen
    fn = matfiles(i).name;
    load(fn);
    %% Clean
    res.larsson.clean = executeLarssonTrilateration(data);
    plotSolver(fn,res.larsson.clean,'g','x','Larsson Clean')
    res.faber.clean = executeFabertMultiLateration2(data);
    plotSolver(fn,res.faber.clean,'g','o','Faber Clean')
    title('Clean data');
    
    %% With noise
    data.Distances = createUWBNoise(data.Distances,5);
    
    dur = tic;
    res.larsson.noise = executeLarssonTrilateration(data);
    dur = toc(dur);
    plotSolver(fn,res.larsson.noise,'r','x','Larsson Noise');
    durationLarsson = [durationLarsson dur];
    
    dur = tic;
    res.faber.noise = executeFabertMultiLateration(data);
    dur = toc(dur);
    plotSolver(fn,res.faber.noise,'r','o','Faber Noise')
    durationFaber = [durationFaber dur];
    
    title(['ERR_{cleanLars} = ' getCalculatedErrorString(data.TagPositions,res.larsson.clean) ...
        '  ERR_{cleanFab} = ' getCalculatedErrorString(data.TagPositions,res.faber.clean) ...
        '   ||  ERR_{noiseLars} = ' getCalculatedErrorString(data.TagPositions,res.larsson.noise) '  ' ...
        '  ERR_{noiseFab} = ' getCalculatedErrorString(data.TagPositions,res.faber.noise) '  '],'Interpreter','tex');
    
%     axis auto
    f=get(gca,'Children');
    legend([f(or(contains({f.DisplayName},'Faber'),contains({f.DisplayName},'Larsson')))],'Location','best')
end
disp(['Execution Time Larsson: ' num2str(sum(durationLarsson))]);
disp(['Execution Time Fabert: ' num2str(sum(durationFaber))]);
distFig()


