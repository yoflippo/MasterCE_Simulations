function [results] = CompareSolversRunSingle(alg,numAnchors)
close all; clc;

%% ADMINISTRATION
mfilename('fullpath');
curPath = fileparts(mfilename('fullpath'));
apHelper = fullfile(extractBefore(curPath,'SIMULATION'),'SIMULATION','helper');
rmpath(genpath(curPath));
addpath(genpath(curPath));
rmpath(genpath(apHelper));
addpath(genpath(apHelper));
cd(curPath);
apOutput = [ '.' filesep 'output' filesep];

warning on
stat.numanchors = numAnchors;
stat.strnumanchors = num2str(stat.numanchors);

% Ensure capital letter at beginning
Alg = [upper(alg(1)) lower(alg(2:end))];
results = CompareSolversSingle(getHandleSolver(Alg),Alg);

    function handle = getHandleSolver(name)
        switch lower(name)
            case 'vinay'
                handle = @executeVinay1;
            case 'larsson'
                handle = @executeLarssonTrilateration;
            case 'faber2'
                handle = @executeFabertMultiLateration2;
            case 'faber2a'
                handle = @executeFabertMultiLateration2a;
            case 'faber2b'
                handle = @executeFabertMultiLateration2b;
            case 'faber3'
                handle = @executeFabertMultiLateration3;
            case  'faber9'
                handle = @executeFabertMultiLateration9;
            case 'murphy'
                handle = @executeMurphy1;
            otherwise
                error([newline mfilename ': ' newline 'Can not happen!' newline]);
        end
    end
end %FUNCTION