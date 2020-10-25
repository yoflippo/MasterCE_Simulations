function distanceWithNoise = createUWBNoise(distances,percentage)

%% Work in Progress
if percentage > 0.99
    percentage = percentage / 100;
end

% More distance means more variance in the distance measurements
[r,c] = size(distances);

%% Save a file with noise, to make it the same for every run
fullPath = mfilename('fullpath');
r1 = 10000;
c1 = 10;
fullPathFileName = createName(fullPath,r1,c1);
if exist(fullPath,'dir') == 0
    mkdir(fullPath);
    gaussian = randn(r1,c1);
    save(fullPathFileName,'gaussian');
end


if exist(fullPathFileName,'file')
    load(fullPathFileName);
else
    keyboard
end

%% PAPEr: modeling of the TOA-based Distance Measurement Error Using UWB indoor Radio EMasurements
% Tabel 1
% Assume UWB BW of 1000
sigw = 13.6; %cm
mw = 0.09*100; %cm
distanceWithNoise = distances + (log10(1+distances).* ((gaussian(1:r,1:c)*sigw)+mw)); %%20200627

end

function [fullPathFileName] = createName(fullPath,r,c)
nameSaveFile = [mfilename '__' num2str(r) '_' num2str(c) '.mat'];
fullPathFileName = fullfile(fullPath,nameSaveFile);
end