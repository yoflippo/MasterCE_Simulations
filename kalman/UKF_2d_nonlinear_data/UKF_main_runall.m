function UKF_main_runall()
close all; clc;
[ap.thisFile, nm.CurrFile] = fileparts(mfilename('fullpath'));
cd(ap.thisFile)

nameOfdir = 'synced';
apsynced = findSubFolderPath(ap.thisFile,'MATLAB',nameOfdir);

if not(exist(apsynced,'dir'))
    error([newline mfilename ': ' newline 'Folder "' nameOfdir '" does not exist!' newline]);
end
addpath(genpath(apsynced))

cd(apsynced);
files = makeFullPathFromDirOutput(dir('*.mat'));
cd(ap.thisFile)

for nF = 1:length(files)
    [~,errors(nF,:)] = UKF_main_nonlinear(files(nF).fullpath);
end
errors
end