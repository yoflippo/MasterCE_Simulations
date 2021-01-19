function create_uwb_dummy_data_combine_path(blVisible)
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

Files.Anchor = files(contains({files.name}','anchors'));
Files.Path = files(contains({files.name}','path'));

counter = 1;
for nP = 1:length(Files.Path)
    currPathFile = fullfile(Files.Path(nP).folder,Files.Path(nP).name);
    for nA = 1:length(Files.Anchor)
        close all;
        clear data;
        load(currPathFile);
        dataCurrPath = data;
        open(replace(currPathFile,'.mat','.fig'));
        if not(blVisible)
            set(gcf,'Visible','off');
        end
        currAnchorFile = fullfile(Files.Anchor(nA).folder,Files.Anchor(nA).name);
        load(currAnchorFile);
        plot(data.AnchorPositions(:,1), data.AnchorPositions(:,2), 'bv', 'MarkerSize', 8,'LineWidth',3,'DisplayName','Anchor');
        axis('auto xy')
        nameOutput =['..' filesep 'dummy_data_sets' filesep mfilename '_' num2str(counter) '_' data.DateTimeOfCreation ];
        counter = counter + 1;
        
        %% CONCATENATE STRUCTS
        data.TagPositions = dataCurrPath.TagPositions;
        data.Distances = calcDistanceAnchorTag(data.AnchorPositions, data.TagPositions);
        saveas(gcf,nameOutput);
        save(nameOutput,'data');
    end
end
close all;
cd(fileparts(currPath));
cd ..

    function distancesAnchorTag = calcDistanceAnchorTag(AnchorLocations,tagPattern)
        distancesAnchorTag = [];
        for nA2 = 1:length(AnchorLocations)
            Anchor = AnchorLocations(nA2,:);
            for nP2 = 1:length(tagPattern)
                d(nP2) = dis(Anchor, tagPattern(nP2,:));
            end
            distancesAnchorTag = [distancesAnchorTag d'];
        end
    end


    function d = dis(pos1,pos2)
        d = sqrt((pos2(1)-pos1(1))^2+(pos2(2)-pos1(2))^2);
    end

end