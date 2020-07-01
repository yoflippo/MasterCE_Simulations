function create_uwb_dummy_data_savefig()
close all; clearvars; clc;
currPath = mfilename('fullpath');

cd(fileparts(currPath));
cd ..
cd dummy_data
apFigs = pwd;
cd(['..' filesep 'output'])

dirpf = 'figspath';
if ~exist(dirpf,'dir')
    mkdir(dirpf);
end
cd(dirpf);
apFigsOut = pwd;

files = dir([apFigs filesep '*.fig']);
Files.Path = files(contains({files.name}','path'));

for nP = 1:length(Files.Path)
    currPathFile = fullfile(Files.Path(nP).folder,Files.Path(nP).name);
    close all;
    open(currPathFile);
    set(gcf,'Visible','on', 'Position',  [100, 100, 800, 600]);
    hold on;
    axis([-800 800 -800 800]);
    tightAxis
    set(gcf,'WindowState','normal');
    saveas(gcf,['paths_' num2str(nP) '.png']);
end

%% Do the same thing for the ANCHOR configs
apFigs = fullfile(apFigs,'AnchorConfigs');
cd ..
dirpf = 'figsanchor';
if ~exist(dirpf,'dir')
    mkdir(dirpf);
end
cd(dirpf);
apFigsOut = pwd;

files = dir([apFigs filesep '*.fig']);
Files.Path = files(contains({files.name}','anchors'));

for nP = 1:length(Files.Path)
    currPathFile = fullfile(Files.Path(nP).folder,Files.Path(nP).name);
    close all;
    open(currPathFile);
    set(gcf,'Visible','on', 'Position',  [100, 100, 800, 600]);
    hold on;
    axis([-1100 1100 -1100 1100]);
    tightAxis
    set(gcf,'WindowState','normal');
    saveas(gcf,['anchor_' num2str(nP) '.png']);
end

close all;
cd(fileparts(currPath));

end