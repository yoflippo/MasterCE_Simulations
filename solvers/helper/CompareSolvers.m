function [result] = CompareSolvers(funhandle1,name1,funhandle2,name2,blPlot,blSavePlot,blUWBnoise,blPlotClean,blDuration)
warning off
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

% Find .mat files with dummy data
oldPath = pwd;
cd('dummy_data_sets');
matfiles = dir(['*.mat']);
matfiles(~contains({matfiles.name},'uwb'))=[];
load(matfiles(1).name);
cd(oldPath);

% Give number of dummy data files you want to use
numberOfPlotsToOpen = 40;
if numberOfPlotsToOpen >  length(matfiles)
    numberOfPlotsToOpen = length(matfiles);
end

%% Plot Results
for i = 1:numberOfPlotsToOpen
    result.name1 = name1;
    result.name2 = name2;
    fn = matfiles(i).name;
    load(fn);
    [~,nameLoadedMat] = fileparts(fn);
    
    %% Measure duration OR Trilaterate
    if blDuration
        dur = @() funhandle1(data);
        result.fun1.duration.clean{i} = timeit(dur);
        dur = @() funhandle2(data);
        result.fun2.duration.clean{i} = timeit(dur);
        
        % With noise
        if blUWBnoise
            data.Distances = createUWBNoise(data.Distances,20);
            name.noise = 'UWB-noise';
        else
            data.Distances = addGaussianNoise(data.Distances,1);
            name.noise = 'Gaussian-noise';
        end
        dur = @() funhandle1(data);
        result.fun1.duration.noise{i} = timeit(dur);
        dur = @() funhandle2(data);
        result.fun2.duration.noise{i} = timeit(dur);
    else
        %% Trilateration
        % Clean
        result.fun1.locations.clean{i} = funhandle1(data);
        result.fun2.locations.clean{i} = funhandle2(data);
        
        % With noise
        if blUWBnoise
            data.Distances = createUWBNoise(data.Distances,20);
            name.noise = 'UWB-noise';
        else
            data.Distances = addGaussianNoise(data.Distances,1);
            name.noise = 'Gaussian-noise';
        end
        result.fun1.locations.noise{i} = funhandle1(data);
        result.fun2.locations.noise{i} = funhandle2(data);
        
        %% Calculate errors
        % Difference between calculated positions and their distance to the
        % anchors MINUS the measured distances
        result.error.fun1.Pos.clean{i} = getErrorDistancesPosition(data.AnchorPositions,data.Distances,result.fun1.locations.clean{i});
        result.error.fun2.Pos.clean{i} = getErrorDistancesPosition(data.AnchorPositions,data.Distances,result.fun2.locations.clean{i});
        result.error.fun1.Pos.noise{i} = getErrorDistancesPosition(data.AnchorPositions,data.Distances,result.fun1.locations.noise{i});
        result.error.fun2.Pos.noise{i} = getErrorDistancesPosition(data.AnchorPositions,data.Distances,result.fun2.locations.noise{i});
        
        %     result.error.DiffLocations.clean1(i) = getErrorLocations(data.TagPositions,res.fun1.locations.clean);
        %     result.error.DiffLocations.clean2(i) = getErrorLocations(data.TagPositions,res.fun2.locations.clean);
        %     result.error.DiffLocations.noise1(i) = getErrorLocations(data.TagPositions,res.fun1.locations.noise);
        %     result.error.DiffLocations.noise2(i) = getErrorLocations(data.TagPositions,res.fun2.locations.noise);
        
        % Difference between calculated distance and real distance (only
        % possible due to simulation OR real accurate measurements)
        result.error.fun1.Dist.noise{i} = getErrorDistances(data.AnchorPositions,data.TagPositions,result.fun1.locations.noise{i});
        result.error.fun2.Dist.noise{i} = getErrorDistances(data.AnchorPositions,data.TagPositions,result.fun2.locations.noise{i});
        
        %% Make plots
        if blPlot
            if blPlotClean
                % CLEAN
                if round(result.error.fun1.Pos.clean{i} ,1) > round(result.error.fun2.Pos.clean{i} ,1)
                    strcolc = '\color{red}';
                else
                    strcolc = '\color{black}';
                end
                plotSolver(fn,result.fun1.locations.clean{i},'r','o',[name1 ' Clean'])
                plotSolver(fn,result.fun2.locations.clean{i},'g','o',[name2 ' Clean'])
                
                title(['Clean: ' strcolc 'e_{pos' name1 '}=' num2str(round(result.error.fun1.Pos.clean{i},1))  ...
                    '  e_{pos' name2 '}=' num2str(round(result.error.fun2.Pos.clean{i},1)) ],'Interpreter','tex');
                f=get(gca,'Children');
                legend(f(or(contains({f.DisplayName},name1),contains({f.DisplayName},name2))),'Location','best')
                
                if blSavePlot
                    %                 export_fig(gcf,[mfilename num2str(i) '_' nameLoadedMat '_CLEAN.png'],'-transparent','-r300');
                    saveas(gcf,[mfilename num2str(i) '_' nameLoadedMat '_CLEAN.png']);
                end
            else
                % WITH NOISE
                if round(result.error.fun1.Pos.noise{i},1) > round(result.error.fun2.Pos.noise{i},1)
                    strcol1 = '\color{red}';
                else
                    strcol1 = '\color{black}';
                end
                
                if round(result.error.fun1.Dist.noise{i} ,1) > round(result.error.fun2.Dist.noise{i},1)
                    strcol2 = '\color{red}';
                else
                    strcol2 = '\color{black}';
                end
                plotSolver(fn,result.fun1.locations.noise{i},'r','x',[name1 ' Noise'],1,true);
                plotSolver(fn,result.fun2.locations.noise{i},'g','x',[name2 ' Noise'],1.5);
                
                title([name.noise ': '  strcol1 'e_{pos' name1 '}=' num2str(round(result.error.fun1.Pos.noise{i} ,1))  ...
                    '  e_{pos' name2 '}=' num2str(round(result.error.fun2.Pos.noise{i} ,1))  ...
                    strcol2 '  |  e_{dis' name1 '}=' num2str(round(result.error.fun1.Dist.noise{i},1))  ...
                    '  e_{dis' name2 '}=' num2str(round(result.error.fun2.Dist.noise{i},1)) ],'Interpreter','tex');
                
                f=get(gca,'Children');
                legend(f(or(contains({f.DisplayName},name1),contains({f.DisplayName},name2))),'Location','best')
                
                if blSavePlot
                    %                 export_fig(gcf,[mfilename num2str(i) '_' nameLoadedMat '_NOISE.png'],'-transparent','-r300');
                    saveas(gcf,[mfilename num2str(i) '_' nameLoadedMat '_NOISE.png']);
                end
            end
            pause(0.5);
        end
    end
end
if blPlot
    distFig()
end
warning on
end
