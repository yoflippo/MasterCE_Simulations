function runallComparisonSingle()

close all; clc; clearvars;
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
nm.dirOutput = 'output';
ap.dummydata = fullfile(pwd,nm.dummydata);
ap.anchorsets = fullfile(ap.dummydata,nm.anchorsets);
ap.dummydatasets = fullfile(pwd,nm.dummydatasets);
ap.dirOutput = fullfile(ap.curPath,nm.dirOutput);

cd(ap.anchorsets)
anchorfiles= dir('*.mat');
cd(ap.curPath)

strExtraInfo = 'paperuwbnoise7ancsScaled2';
solvertypes = {'larsson','murphy','faber2a'};

[ap,results] = runAllAnchorFiles(ap,nm,anchorfiles,solvertypes);
saveAllResults(ap,strExtraInfo,results)
cd(ap.curPath)









    function [ap,results] = runAllAnchorFiles(ap,nm,anchorfiles,solvertypes)
        for nS = 1:length(anchorfiles)
            ap = removeAndCleanDummyDataSet(ap,nm,anchorfiles,nS);
            createNewDummyDataSet(ap);
            tmp = runSolverForAnchorfile(ap,anchorfiles,solvertypes,nS);
            results(1:length(tmp),nS) = tmp; 
        end
    end

    function [results] = runSolverForAnchorfile(ap,anchorfiles,solvertypes,nS)
        cd(ap.dummydatasets)
        numAnchors = str2double(anchorfiles(nS).name(regexp(anchorfiles(nS).name,'[0-9]')));   % Extract number of anchors
        for nT = 1:length(solvertypes)
            results(1,nT) = CompareSolversRunSingle(solvertypes{nT},numAnchors);
        end
    end

    function createNewDummyDataSet(ap)
        try
            rmdir(ap.dummydatasets,'s');
        catch
        end
        mkdir(ap.dummydatasets)
        create_uwb_dummy_data_combine_path(false)
    end

    function [ap] = removeAndCleanDummyDataSet(ap,nm,anchorfiles,nS)
        cd(ap.dummydata)
        matfiles = dir('*.mat');
        figfiles = dir('*.fig');
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
    end

    function deleteFileFromStruct(struct)
        for i = 1:length(struct)
            delete(fullfile(struct(i).folder,struct(i).name));
        end
    end

    function saveAllResults(ap,strExtraInfo,results)
        ap.matFileName = fullfile(ap.dirOutput,[mfilename '_results_' strExtraInfo '.mat']);
        save(ap.matFileName,'results');
        makeLatexTableFromSimulationResults(ap.matFileName);
        FromSimulationResultsMakeErrorAndDurationGraph(ap.matFileName);
    end

end