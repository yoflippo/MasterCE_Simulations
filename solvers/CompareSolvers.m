function [result] = CompareSolvers(funhandle1,name1,funhandle2,name2,blPlot,blSavePlot,blUWBnoise)
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

% Find .mat files with dummy data
matfiles = dir(['*.mat']);
matfiles(~contains({matfiles.name},'uwb'))=[];
load(matfiles(1).name);

% Give number of dummy data files you want to use
numberOfPlotsToOpen = 40;
if numberOfPlotsToOpen >  length(matfiles)
    numberOfPlotsToOpen = length(matfiles);
end

result.name1 = name1;
result.name2 = name2;

%% Plot Results
for i = 1:numberOfPlotsToOpen
    fn = matfiles(i).name;
    load(fn);
    
    %% Clean
    dur = tic;
    res.fun1.clean = funhandle1(data);
    result.fun1.clean = res.fun1.clean;
    result.duration.clean1(i) = toc(dur);
    
    dur = tic;
    res.fun2.clean = funhandle2(data);
    result.fun2.clean = res.fun2.clean;
    result.duration.clean2(i) = toc(dur);
    %     if blPlot
    %      plotSolver(fn,res.fun1.clean,'g','x',[name1 ' Clean'])
    %         plotSolver(fn,res.fun2.clean,'g','o',[name2 ' Clean'])
    %         title('Clean data');
    %     end
    
    %% With noise
    if blUWBnoise
        data.Distances = createUWBNoise(data.Distances,5);
    else
        data.Distances = createNoise(data.Distances);
    end
    
    dur = tic;
    res.fun1.noise = funhandle1(data);
    result.fun1.noise = res.fun1.clean;
    result.duration.noise1(i) = toc(dur);
    
    dur = tic;
    res.fun2.noise = funhandle2(data);
    result.fun2.noise = res.fun2.clean;
    result.duration.noise2(i)  = toc(dur);
    
    %% Finish plot and save data
    result.error.clean1(i) = getErrorLocations(data.TagPositions,res.fun1.clean);
    result.error.clean2(i) = getErrorLocations(data.TagPositions,res.fun2.clean);
    result.error.noise1(i) = getErrorLocations(data.TagPositions,res.fun1.noise);
    result.error.noise2(i) = getErrorLocations(data.TagPositions,res.fun2.noise);
    
    result.error.DiffDisSqr1(i) = getErrorDistances(data.AnchorPositions,data.TagPositions,res.fun1.noise);
    result.error.DiffDisSqr2(i) = getErrorDistances(data.AnchorPositions,data.TagPositions,res.fun2.noise);
    
    %     [result.error.DiffDisSqr1(i) result.error.DiffDisSqr2(i) ...
    %         getErrorLocations(data.TagPositions,res.fun1.noise) ...
    %         getErrorLocations(data.TagPositions,res.fun2.noise)]
    
    result.errorstr.clean1{i} = num2str(result.error.clean1(i));
    result.errorstr.clean2{i} = num2str(result.error.clean2(i));
    result.errorstr.noise1{i} = num2str(result.error.noise1(i));
    result.errorstr.noise2{i} = num2str(result.error.noise2(i));
    
    if round(result.error.DiffDisSqr2(i),1) > round(result.error.DiffDisSqr1(i),1)
        strcol1 = '\color{red}';
    else
        strcol1 = '\color{black}';
    end
    
    
    if round(result.error.noise2(i),1) > round(result.error.noise1(i),1)
        strcol2 = '\color{red}';
    else
        strcol2 = '\color{black}';
    end
    
    if blPlot
        plotSolver(fn,res.fun1.noise,'r','x',[name1 ' Noise'],1);
        plotSolver(fn,res.fun2.noise,'g','x',[name2 ' Noise'],1.5);
        
        title([strcol1 'e_{' name1 '}=' num2str(round(result.error.DiffDisSqr1(i),1))  ...
            '  e_{' name2 '}=' num2str(round(result.error.DiffDisSqr2(i),1))  ...
            strcol2 '  |  e_{ms' name1 '}=' num2str(round(result.error.noise1(i),1))  ...
            '  e_{ms' name2 '}=' num2str(round(result.error.noise2(i),1)) ],'Interpreter','tex');
        f=get(gca,'Children');
        legend(f(or(contains({f.DisplayName},name1),contains({f.DisplayName},name2))),'Location','best')
        if blSavePlot
            export_fig(gcf,[mfilename num2str(i) '.png'],'-transparent','-r300');
        end
    end
    pause(0.2);
end
if blPlot
    distFig()
end
warning on
end
