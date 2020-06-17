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

%% Some script variables
AnchorLocations = [];
repCounter = 1;
data.DateTimeOfCreation = char(datetime('now','Format','yyMMddHHmmss'));

%% Create figure
hFig = figure('WindowState','maximized');
setFigure();

%% Draw anchors
posA = 1600;
% SQUARE
center = 300;
AnchorLocations = [-600 400; 0 center; 600 400];
nameCurr = ['_colin_' num2str(center)];
data.nameCurr = nameCurr;

% % TRIANGLE
% [AnchorLocations(:,1), AnchorLocations(:,2)] = topTriangle(0,posA);
% nameCurr = ['Triangle' num2str(posA/2)];
% data.nameCurr = nameCurr;

hp = plot(AnchorLocations(:,1), AnchorLocations(:,2), 'bv', 'MarkerSize', 8,'LineWidth',3,'DisplayName','Anchor');

%% Callback functions

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
            saveData(nameOutput)
            close all;
            return
            
        elseif isequal(evnt.Key,'a')
            close all;
            return
        end
    end

    function saveData(nameOut)
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
        clf;
        set(hFig,'WindowKeyPressFcn',@KeyPressFcn);
        axis([-1000 1000 -1000 1000]);
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
end %function
