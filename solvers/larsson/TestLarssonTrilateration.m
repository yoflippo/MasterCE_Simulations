%% Test Larsson
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
% % % Create noise matrices, so noise is the same for the same number of
% % % ANCHORS
% % % noise = createNoiseForMatrices(length(data.TagPositions),true);


%% Plot Results
for i = 1:numberOfPlotsToOpen
    fn = matfiles(i).name;
    load(fn);
    %% Clean
    res.clean = executeLarssonTrilateration(data);
    plotSolver(fn,res.clean,'g','x','Larsson Clean')
    title('Clean data');
    
    %% With noise
    % % %     [r,c] = size(data.Distances);
    % % %     data.Distances = data.Distances + noise{c}; % times 6 gives approx. 20 cm of variation
    
    % UWB noise due to larger distance
    data.Distances = createUWBNoise(data.Distances,5);
    
    res.noise = executeLarssonTrilateration(data);
    plotSolver(fn,res.noise,'r','x','Larsson Clean')
    title(['Error_{clean} is ' getCalculatedErrorString(data.TagPositions,res.clean) ...
        '                   Error_{noise} is ' getCalculatedErrorString(data.TagPositions,res.noise)],'Interpreter','tex');
    f=get(gca,'Children');
    legend([f(or(contains({f.DisplayName},'Faber'),contains({f.DisplayName},'Larsson')))],'Location','best')
    
    [~, sE] = getCalculatedErrorString(data.TagPositions,res.noise);
    sumError = sumError + sE;
end
sumError
distFig('Tight',true)


