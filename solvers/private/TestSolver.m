function TestSolver(funhandle,name)

mfilename('fullpath')
curPath = fileparts(mfilename('fullpath'));
apHelper = fullfile(extractBefore(curPath,'SIMULATION'),'SIMULATION','helper');
rmpath(genpath(curPath));
addpath(genpath(curPath));
rmpath(genpath(apHelper));
addpath(genpath(apHelper));
cd(curPath);

% Find .mat files with dummy data
matfiles = dir(['**' filesep '*.mat']);
matfiles(~contains({matfiles.name},'uwb'))=[];
matfiles(contains({matfiles.folder},'dummy_data'))=[];
load(matfiles(1).name);

% Give number of dummy data files you want to use
numberOfPlotsToOpen = 30;
if numberOfPlotsToOpen >  length(matfiles)
    numberOfPlotsToOpen = length(matfiles);
end

sumError = 0;
%% Plot Results
for i = 1:numberOfPlotsToOpen
    fn = matfiles(i).name;
    load(fn);
    
    res.clean = funhandle(data);
    plotSolver(fn,res.clean,'g','o',[name ' Clean'])
    title('Clean data');
    
    % UWB noise due to larger distance
    data.Distances = createUWBNoise(data.Distances,5);
    
    res.noise = funhandle(data);
    plotSolver(fn,res.noise,'r','o',[name ' Clean'])
%     title(['Error_{clean} is ' getCalculatedErrorString(data.TagPositions,res.clean) ...
%         '                   Error_{noise} is ' getCalculatedErrorString(data.TagPositions,res.noise)],'Interpreter','tex');
    f=get(gca,'Children');
    legend([f(or(contains({f.DisplayName},name),contains({f.DisplayName},'Larsson')))],'Location','best')
    
%     [~, sE] = getCalculatedErrorString(data.TagPositions,res.noise);
%     if ~isnan(sE)
%         sumError = sumError + sE;
%     end
end
sumError
distFig('Tight',true)

end