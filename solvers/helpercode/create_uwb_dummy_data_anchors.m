function create_uwb_dummy_data_anchors()
% CREATE_UWB_DUMMY_DATA
%
% ------------------------------------------------------------------------
%    Copyright (C) 2020  M. Schrauwen (markschrauwen@gmail.com)
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
% ------------------------------------------------------------------------
%
%
% BY: 2020  M. Schrauwen (markschrauwen@gmail.com)
%
% Execute this function like a script. Follow the instructions. The data
% will be save in a .mat file.

% $Revisi0n: 0.0.0 $  $Date: 2020-04-16 $
% Creation of this script

close all; clearvars; clc;

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

%% Some script variables
AnchorLocations = [];
repCounter = 1;
data.DateTimeOfCreation = char(datetime('now','Format','yyMMddHHmmss'));

%% Create figure
AnchorLocations = [
        -300 800;
        -800 -500;
    800 -800;
    700 700;
    -100 -900;
    -700 400;
    800 0;
    ];

for nA = 3:length(AnchorLocations)  
    [nameOutput,pathAndNameOutput] = returnFullPathAndNameOfOutputfile(nA);
    
    setFigure();
    hp = plot(AnchorLocations(1:nA,1), AnchorLocations(1:nA,2), 'bv', 'MarkerSize', 8,'LineWidth',3,'DisplayName','Anchor');
    pause(0.1);
    saveData(pathAndNameOutput,AnchorLocations(1:nA,:));
    close all;
end


%% Callback functions

    function [nameOutputFile,pathAndNameOutput] = returnFullPathAndNameOfOutputfile(nA)
        strLengthAnchorLocations = num2str(nA);
        nameOutputFile = [strLengthAnchorLocations '_anchors'];
        data.nameCurr = nameOutputFile;
        pathAnchorConfigs = findSubFolderPath(fileparts(pwd),'solvers','AnchorConfigs');
        pathAndNameOutput = fullfile(pathAnchorConfigs,nameOutputFile);
    end

    function KeyPressFcn(~,evnt)
        [r, c] = size(AnchorLocations);
        if r < 2
            uiwait(msgbox('Create AT LEAST 2 anchors!'));
            return
        end
        if isequal(evnt.Key,'escape')
            nameOutput =['.' filesep mfilename '_' nameCurr];
            %             nameOutput =['.' filesep 'dummy_data' filesep mfilename '_' data.DateTimeOfCreation nameCurr];
            saveas(gcf,nameOutput);
            saveData(nameOutput,AnchorLocations)
            close all;
            return
            
        elseif isequal(evnt.Key,'a')
            close all;
            return
        end
    end

    function saveData(nameOut,AnchorLocations)
        if ~exist('nameOut','var')
            nameOut = '';
        end
        repCounter = repCounter + 1;
        set(gca,'ButtonDownFcn','')
        saveas(gcf,nameOut)
        data.AnchorPositions = AnchorLocations;
        save(nameOut,'data');
    end

    function setFigure()
        hFig = figure('WindowState','maximized');
        clf;
        set(hFig,'WindowKeyPressFcn',@KeyPressFcn);
        axis([-1500 1500 -1500 1500]);
        hAxis = gca;
        hAxis.XAxisLocation = 'origin'; hAxis.YAxisLocation = 'origin';
        grid on; grid minor; hold on;
        set(gca,'ButtonDownFcn',@MousePressAnchor)
    end

    function clearExistingData()
        AnchorLocations = [];
    end

    function [xc,yc] = topTriangle(x1,x2)
        a = (x2-x1)/2;
        b = sqrt(5*a^2);
        xc = [x1 a x2]';
        yc = [0 b 0]';
        % centre the triangle
        xc = xc - mean(xc);
        yc = yc - mean(yc);
    end


    function [output] = findSubFolderPath(absolutePath,rootFolder,nameFolder)
        
        if ~contains(absolutePath,rootFolder)
            error([newline mfilename ': ' newline 'Rootfolder not within absolutePath' newline]);
        end
        startDir = fullfile(extractBefore(absolutePath,rootFolder),rootFolder);
        dirs = dir([startDir filesep '**' filesep '*']);
        dirs(~[dirs.isdir])=[];
        dirs(contains({dirs.name},'.'))=[];
        dirs(~contains({dirs.name},nameFolder))=[];
        if length(dirs)>1
            warning([newline mfilename ': ' newline 'Multiple possible folders found' newline]);
            output = dirs;
        end
        output = fullfile(dirs(1).folder,dirs(1).name);
    end

end %function
