function create_uwb_dummy_data()
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
blKeyAPressed = false;
AnchorLocations = [];
distancesAnchorTag = [];
repCounter = 1;
data.DateTimeOfCreation = char(datetime('now','Format','yyMMddHHmmss'));

%% Create figure
hFig = figure('WindowState','maximized');
setFigure();

%% Draw Pattern
uiwait(msgbox('Press left mouse button down and draw a pattern, to stop release the button'));
tagPatternObj = imfreehand('Closed',false);
tagPattern = tagPatternObj.getPosition;
tagPatternObj.delete; clear tagPatternObj;
setFigure();

%% Draw anchors
uiwait(msgbox('Click on the axis to create ANCHORS, press ESC to stop, press A to add another set with different Anchor placements'));
set(gca,'ButtonDownFcn',@MousePressAnchor)


%% Callback functions
    function MousePressAnchor(hObject, eventdata, handles)
        currentPress = eventdata.IntersectionPoint(1:2);
        AnchorLocations = [AnchorLocations; currentPress ];
        hold on;
        hp = plot(currentPress(1), currentPress(2), 'bv', 'MarkerSize', 8,'LineWidth',3,'DisplayName','Anchor');
        drawnow
    end

    function KeyPressFcn(~,evnt)
        [r, c] = size(AnchorLocations);
        if r < 2
            uiwait(msgbox('Create AT LEAST 2 anchors!'));
            return
        end
        if isequal(evnt.Key,'escape')
            if blKeyAPressed
                saveData('repetitionPattern');
            else
                saveData()
            end
            % Save a figure with only the pattern for adding anchors in the future
            nameOutput =[mfilename '_' data.DateTimeOfCreation '_CLEAN'];
            clearExistingData()
            setFigure();
            saveas(gcf,nameOutput);
            close all;
            return
        elseif isequal(evnt.Key,'a')
            saveData('repetitionPattern');
            clearExistingData()
            setFigure();
            blKeyAPressed = true;
        end
    end

    function saveData(nameOut)
        if ~exist('nameOut','var')
            nameOut = '';
        end
        %         data.DateTimeOfCreation = char(datetime('now','Format','yyMMddHHmmss'));
        nameOutput =[mfilename '_'   data.DateTimeOfCreation '_' nameOut '_' num2str(repCounter)];
        repCounter = repCounter + 1;
        set(gca,'ButtonDownFcn','')
        saveas(gcf,nameOutput)
        calcDistanceAnchorTag();
        data.AnchorPositions = AnchorLocations;
        data.TagPositions = tagPattern;
        data.Distances = distancesAnchorTag;
        save(nameOutput,'data');
        uiwait(msgbox('Data is saved in a ".mat" file and the figure in a ".fig" file in the directory of this script'));
    end

    function calcDistanceAnchorTag()
        for nA = 1:length(AnchorLocations)
            Anchor = AnchorLocations(nA,:);
            for nP = 1:length(tagPattern)
                d(nP) = dis(Anchor, tagPattern(nP,:));
            end
            distancesAnchorTag = [distancesAnchorTag d'];
        end
    end

    function setFigure()
        clf;
        set(hFig,'WindowKeyPressFcn',@KeyPressFcn);
        axis([-1000 1000 -1000 1000]);
        hAxis = gca;
        hAxis.XAxisLocation = 'origin'; hAxis.YAxisLocation = 'origin';
        grid on; grid minor; hold on;
        set(gca,'ButtonDownFcn',@MousePressAnchor)
        try
            hp = plot(tagPattern(:,1),tagPattern(:,2));
            % don't show legend information
            set(get(get(hp(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        catch
        end
    end

    function d = dis(pos1,pos2)
        d = sqrt((pos2(1)-pos1(1))^2+(pos2(2)-pos1(2))^2);
    end

    function clearExistingData()
        AnchorLocations = [];
        distancesAnchorTag = [];
    end
end %function
