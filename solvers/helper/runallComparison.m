close all; clc; clearvars;

%% ADMINISTRATION
mfilename('fullpath');
ap.curPath = fileparts(mfilename('fullpath'));
ap.Helper = fullfile(extractBefore(ap.curPath,'SIMULATION'),'SIMULATION','helper');
rmpath(genpath(ap.curPath));
addpath(genpath(ap.curPath));
rmpath(genpath(ap.Helper));
addpath(genpath(ap.Helper));
cd(ap.curPath);
nm.dummydatasets = 'dummy_data_sets';
nm.dummydata = 'dummy_data';
nm.anchorsets = 'AnchorConfigs';
ap.dummydata = fullfile(pwd,nm.dummydata);
ap.anchorsets = fullfile(ap.dummydata,nm.anchorsets);
ap.dummydatasets = fullfile(pwd,nm.dummydatasets);

% Get the anchor files
cd(ap.anchorsets)
anchorfiles= dir(['*.mat']);
cd(ap.curPath)

%% Iterate over different configurations
solvertypes = {'larsson','vinay','murphy','faber2a'};
combinations = nchoosek(1:length(solvertypes),2);

for nS = 2:length(anchorfiles) %anchor sets
    % Remove anchor set from dummy_data folder
    cd(ap.dummydata)
    matfiles = dir(['*.mat']);
    figfiles = dir(['*.fig']);
    cd(ap.curPath)
    matfiles(contains({matfiles.name},nm.dummydata))=[];
    figfiles(contains({figfiles.name},nm.dummydata))=[];
    deleteFileFromStruct(matfiles);
    deleteFileFromStruct(figfiles);
    
    % Copy anchor set to dir
    ap.curfile.mat = fullfile(anchorfiles(nS).folder,anchorfiles(nS).name);
    ap.curfile.fig = replace(ap.curfile.mat,'.mat','.fig');
    copyfile(ap.curfile.mat,ap.dummydata);
    copyfile(ap.curfile.fig,ap.dummydata);
    
    %% Create a new set
    rmdir(ap.dummydatasets,'s');
    mkdir(ap.dummydatasets)
    create_uwb_dummy_data_combine_path(false)
    
    %% Perform analysis
    % Extract number of anchors
    numAnchors = str2double(anchorfiles(nS).name(regexp(anchorfiles(nS).name,'[0-9]')));
    % Go over solver set
    for nT = 1:length(combinations)
        runallComparison_results(nT,nS) = executeCompareSolversRun(solvertypes{combinations(nT,1)},...
            solvertypes{combinations(nT,2)},numAnchors);
    end
    % Save all the results for later analysis
    save([mfilename '_results.mat'],'runallComparison_results');
end

%% FINALIZATION
rmpath(genpath(ap.curPath));
rmpath(genpath(ap.Helper));

% Shutdown
pause(300);
system('shutdown -s');

function deleteFileFromStruct(struct)
for i = 1:length(struct)
    delete(fullfile(struct(i).folder,struct(i).name));
end
end

function [result] = executeCompareSolversRun(name1,name2,numAnchors)
result.gaussian = CompareSolversRun(name1,name2,numAnchors);
result.uwbnoise = CompareSolversRun(name1,name2,numAnchors,'uwbnoise');
result.duration = CompareSolversRun(name1,name2,numAnchors,'duration');
end