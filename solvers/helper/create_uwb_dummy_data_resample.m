function create_uwb_dummy_data_resample(blVisible)
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
cd ..
cd('dummy_data');
files = dir('*.mat');

% rmdirIf(['..' filesep 'dummy_data_sets']);
% mkdirIf(['..' filesep 'dummy_data_sets'])

Files.Path = files(contains({files.name}','path'));


for nP = 1:length(Files.Path)
    currPathFile = fullfile(Files.Path(nP).folder,Files.Path(nP).name);
    close all;
    clear data;
    load(currPathFile);
    dataCurrPath = data;
    open(replace(currPathFile,'.mat','.fig'));
    if not(blVisible)
        set(gcf,'Visible','off');
    end
    datax = data.TagPositions(:,1);
    datay = data.TagPositions(:,2);
    len = length(datax);
    lenDes = 1000; %DESIRED LENGTH
    try
        tagPatternX = interp1(1:len, datax',1:len/lenDes:len,'pchip')';
        tagPatternY = interp1(1:len, datay',1:len/lenDes:len,'pchip')';
        
        data.TagPositions = [tagPatternX tagPatternY];
        %     set(gcf,'Visible','on')
        
        hold off;
        plot(tagPatternX,tagPatternY);
        grid on; grid minor; hold on;
        axis([-1500 1500 -1500 1500]);
        hAxis = gca;
        hAxis.XAxisLocation = 'origin'; hAxis.YAxisLocation = 'origin';
        
        saveas(gcf,replace(currPathFile,'.mat','.fig'));
        save(currPathFile,'data');
    catch
    end
end
close all;
cd(fileparts(currPath));
cd ..




end