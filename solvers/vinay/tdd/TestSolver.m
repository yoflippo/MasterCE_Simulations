function TestSolver(funhandle,name)

mfilename('fullpath')
curPath = fileparts(mfilename('fullpath'));
apHelper = fullfile(extractBefore(curPath,'SIMULATION'),'SIMULATION','helper');
rmpath(genpath(curPath));
addpath(genpath(curPath));
rmpath(genpath(apHelper));
addpath(genpath(apHelper));
cd(curPath);
cd ..

%% Read the same data as tri-loc2.py in Pain/big/leftlef/corrected
load('dataFromVinay.mat');
% clean data
distances = dataFromVinay(3:71,[6,12,18]); %only load data that is valid
distances = table2array(distances);
distances = str2double(distances);
data.distances = distances;
anchorpos = [table2array(dataFromVinay(3,3:4));
    table2array(dataFromVinay(3,9:10));
    table2array(dataFromVinay(3,15:16))]; 
anchorpos = str2double(anchorpos);
data.anchorpos = anchorpos;

res.clean = funhandle(data);
plotSolver(fn,res.clean,'g','o',[name ' Clean'])
title('Clean data');

end
