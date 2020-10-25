function create_uwb_dummy_data_anchors_scale()
close all; clearvars; clc;

if ~exist('blVisible','var')
    blVisible = false;
end

%% CHECKS
if ~license('test', 'image_toolbox')
    msgbox('You have to install the Matlab image toolbox, this script will not work without it')
    return
end

ver = version('-release');
if str2double(ver(1:4)) < 2018
    msgbox('You should work on Matlab version 2018 or higher')
    return
end
clear ver

currPath = mfilename('fullpath');
cd(fileparts(currPath));
cd(fullfile('..','dummy_data','AnchorConfigs'));
files = dir('*.mat');

Files.Anchors = files(contains({files.name}','anchors'));

for nP = 1:length(Files.Anchors)
    currPathFile = fullfile(Files.Anchors(nP).folder,Files.Anchors(nP).name);
    close all;
    clear data;
    
    load(currPathFile);
    dataCurrPath = data;
    
    %% Scale anchors positions
    data.AnchorPositions = data.AnchorPositions * 1.5;
    nameFig = replace(currPathFile,'.mat','.fig');
    set(gcf,'Visible','on', 'Position',  [100, 100, 800, 600]);
    plot(data.AnchorPositions(:,1), data.AnchorPositions(:,2), 'bv', 'MarkerSize', 8,'LineWidth',3,'DisplayName','Anchor');
    hold off;
    grid on; grid minor; hold on;
    axis([-1500 1500 -1500 1500]);
    hAxis = gca;
    hAxis.XAxisLocation = 'origin'; hAxis.YAxisLocation = 'origin';
    
    saveas(gcf,nameFig);
    save(currPathFile,'data'); 
end
close all;
cd(fileparts(currPath));
cd ..


end