function distanceWithNoise = addGaussianNoise(distances,factor)
if ~exist('factor','var')
    factor = 1;
end
[r,c] = size(distances);

%% Save a file with noise, to make it the same for every run
fullPath = mfilename('fullpath');
if exist(fullPath,'dir') == 0
    mkdir(fullPath);
end

nameSaveFile = [mfilename '__' num2str(r) '_' num2str(c) '.mat'];
fullPathFileName = fullfile(fullPath,nameSaveFile);
if exist(fullPathFileName,'file')
    load(fullPathFileName);
else
    noise = randn(r,c);
    save(fullPathFileName,'noise');
end

%% Finish
distanceWithNoise = distances+(factor*noise);