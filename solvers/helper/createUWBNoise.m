function distanceWithNoise = createUWBNoise(distances,percentage)

%% Work in Progress
if percentage > 0.99
    percentage = percentage / 100;
end

% More distance means more variance in the distance measurements
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
    gaussian = randn(r,c);
    save(fullPathFileName,'gaussian');
end

signs = ones(r,c); %sign(gaussian);
% distanceWithNoise = distances + ((percentage*distances) .* signs) + gaussian; %%20200623
% distanceWithNoise = distances + (percentage * distances .* signs .* gaussian);
% distanceWithNoise = distances + (log(1+distances).* gaussian); %%20200627

%% PAPEr: modeling of the TOA-based Distance Measurement Error Using UWB indoor Radio EMasurements
% Tabel 1
% Assume UWB BW of 1000
sigw = 13.6; %cm
mw = 0.09*100; %cm
distanceWithNoise = distances + (log10(1+distances).* ((gaussian*sigw)+mw)); %%20200627