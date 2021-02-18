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
    [errors(nF,:),~] = UKF_main_nonlinear(files(nF).fullpath);
    errorsout(nF,:) = [nF errors(nF,:)];
end
errorsout

input.data = errorsout;
input.tablePositioning = 'h';
input.tableColLabels = {'','UWB RMSE [mm]','UKF RMSE [mm]','UKF RTS RMSE [mm]','\% UKF','\% UKF RTS'};
input.dataNanString = '-';
input.tableColumnAlignment = 'c';
input.booktabs = 1;
input.dataFormat = {'%.0f',1,'%.1f',length(input.tableColLabels)-1};
input.tableCaption = 'Results expressed in RMSE are based on ground truth reference. The error reduction is indicated by \%.';
input.tableLabel = 'tab:results:sensorfusion';
latex = latexTable(input);

%% Write to file
ap.outdir = findSubFolderPath([],'UWB','THESIS');
ap.outdir = findSubFolderPath(ap.outdir,'THESIS','results');
filename = fullfile(ap.outdir,'ukfresults.tex');
fid=fopen(filename,'w');
[nrows,~] = size(latex);
for row = 1:nrows
    fprintf(fid,'%s\n',latex{row,:});
end
fclose(fid);
fclose('all');