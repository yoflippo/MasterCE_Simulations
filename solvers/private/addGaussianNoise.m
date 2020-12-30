function distanceWithNoise = addGaussianNoise(distances,factor)
if ~exist('factor','var')
    factor = 1;
end
[r,c] = size(distances);

%% Save a file with noise, to make it the same for every run
fullPath = mfilename('fullpath');
r1 = 10000;
c1 = 10;
fullPathFileName = createName(fullPath,r1,c1);
if exist(fullPath,'dir') == 0
    mkdir(fullPath);
    noise = randn(r1,c1);
    save(fullPathFileName,'noise');
end

if exist(fullPathFileName,'file')
    load(fullPathFileName);
else
    keyboard
end

%% Finish
distanceWithNoise = distances + (factor*noise(1:r,1:c));

end


function [fullPathFileName] = createName(fullPath,r,c)
nameSaveFile = [mfilename '__' num2str(r) '_' num2str(c) '.mat'];
fullPathFileName = fullfile(fullPath,nameSaveFile);
end