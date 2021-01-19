function [result] = CompareSolversSingle(funhandle,name)
warning off

% Find .mat files with dummy data
oldPath = pwd;
cd ..
cd('dummy_data_sets');
matfiles = dir(['*.mat']);
matfiles(~contains({matfiles.name},'uwb'))=[];
load(matfiles(1).name);
cd(oldPath);

% Give number of dummy data files you want to use
numFilesToUse = length(matfiles);
result.name = name;

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
    
    [result] = calculateErrorsTrilateration(data,result,i,name);
    
end
warning on
result.data = data;
end

function [result] = calculateErrorsTrilateration(data,result,nI,name)
if contains(name,'vinay','IgnoreCase',true)
    % Difference between calculated positions and their distance to the
    % anchors MINUS the measured distances
    result.error.dist.clean{nI} = getErrorDistancesPosition(data.AnchorPositions(1:3,1:2),...
        data.DistancesClean(:,1:3),result.locations.clean{nI});
    result.error.dist.noise.gaussian{nI} = getErrorDistancesPosition(data.AnchorPositions(1:3,1:2),...
        data.DistancesClean(:,1:3),result.locations.noise.gaussian{nI});
    result.error.dist.noise.uwb{nI} = getErrorDistancesPosition(data.AnchorPositions(1:3,1:2),...
        data.DistancesClean(:,1:3),result.locations.noise.uwb{nI});
    
    % Difference between calculated distance and real distance (only
    % possible due to simulation OR real accurate measurements)
    result.error.distwithnoise.noise.gaussian{nI} = getErrorDistancesPosition(data.AnchorPositions(1:3,1:2),...
        data.DistancesGaussian(:,1:3),result.locations.noise.gaussian{nI});
    result.error.distwithnoise.noise.uwb{nI} = getErrorDistancesPosition(data.AnchorPositions(1:3,1:2),...
        data.DistancesUWBnoise(:,1:3),result.locations.noise.uwb{nI});
    
    result.error.pos.clean{nI} = getErrorLocations(data.TagPositions,...
        result.locations.clean{nI});
    result.error.pos.noise.gaussian{nI} = getErrorLocations(data.TagPositions,...
        result.locations.noise.gaussian{nI});
    result.error.pos.noise.uwb{nI} = getErrorLocations(data.TagPositions,...
        result.locations.noise.uwb{nI});
else
    result.error.dist.clean{nI} = getErrorDistancesPosition(data.AnchorPositions,...
        data.DistancesClean,result.locations.clean{nI});
    result.error.dist.noise.gaussian{nI} = getErrorDistancesPosition(data.AnchorPositions,...
        data.DistancesClean,result.locations.noise.gaussian{nI});
    result.error.dist.noise.uwb{nI} = getErrorDistancesPosition(data.AnchorPositions,...
        data.DistancesClean,result.locations.noise.uwb{nI});
    
    result.error.distwithnoise.noise.gaussian{nI} = getErrorDistancesPosition(data.AnchorPositions,...
        data.DistancesGaussian,result.locations.noise.gaussian{nI});
    result.error.distwithnoise.noise.uwb{nI} = getErrorDistancesPosition(data.AnchorPositions,...
        data.DistancesUWBnoise,result.locations.noise.uwb{nI});
    
    result.error.pos.clean{nI} = getErrorLocations(data.TagPositions,...
        result.locations.clean{nI});
    result.error.pos.noise.gaussian{nI} = getErrorLocations(data.TagPositions,...
        result.locations.noise.gaussian{nI});
    result.error.pos.noise.uwb{nI} = getErrorLocations(data.TagPositions,...
        result.locations.noise.uwb{nI});
end
end