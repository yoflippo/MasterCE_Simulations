function [result] = CompareSolversSingle(funhandle,name)
warning off

% Find .mat files with dummy data
oldPath = pwd;
cd('dummy_data_sets');
matfiles = dir(['*.mat']);
matfiles(~contains({matfiles.name},'uwb'))=[];
load(matfiles(1).name);
cd(oldPath);

% Give number of dummy data files you want to use
numFilesToUse = length(matfiles);
result.name = name;
%% Plot Results
for i = 1:numFilesToUse
    load(fullfile(matfiles(i).folder,matfiles(i).name));
    
    %% Trilateration
    result.locations.clean{i} = funhandle(data);
    data.DistancesClean = data.Distances;
    dur = @() funhandle(data);
    result.duration.clean{i} = timeit(dur);
    
    data.Distances = addGaussianNoise(data.Distances,10);
    data.DistancesGaussian = data.Distances;
    result.locations.noise.gaussian{i} = funhandle(data);
    dur = @() funhandle(data);
    result.duration.noise.gaussian{i} = timeit(dur);
    
    data.Distances = createUWBNoise(data.DistancesClean,1);
    data.DistancesUWBnoise = data.Distances;
    result.locations.noise.uwb{i} = funhandle(data);
    dur = @() funhandle(data);
    result.duration.noise.uwb{i} = timeit(dur);
    
    %% Duration
    
    
    %% Calculate errors
    % Difference between calculated positions and their distance to the
    % anchors MINUS the measured distances
    result.error.dist.clean{i} = getErrorDistancesPosition(data.AnchorPositions,data.DistancesClean,result.locations.clean{i});
    result.error.dist.noise.gaussian{i} = getErrorDistancesPosition(data.AnchorPositions,data.DistancesClean,result.locations.noise.gaussian{i});
    result.error.dist.noise.uwb{i} = getErrorDistancesPosition(data.AnchorPositions,data.DistancesClean,result.locations.noise.uwb{i});
    
    % Difference between calculated distance and real distance (only
    % possible due to simulation OR real accurate measurements)
    result.error.distwithnoise.noise.gaussian{i} = getErrorDistancesPosition(data.AnchorPositions,data.DistancesGaussian,result.locations.noise.gaussian{i});
    result.error.distwithnoise.noise.uwb{i} = getErrorDistancesPosition(data.AnchorPositions,data.DistancesUWBnoise,result.locations.noise.uwb{i});
    
    result.error.pos.clean{i} = getErrorLocations(data.TagPositions,result.locations.clean{i});
    result.error.pos.noise.gaussian{i} = getErrorLocations(data.TagPositions,result.locations.noise.gaussian{i});
    result.error.pos.noise.uwb{i} = getErrorLocations(data.TagPositions,result.locations.noise.uwb{i});
end
warning on
result.data = data;
end
