function create_uwb_dummy_data_path()
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

%% Some script variables
data.DateTimeOfCreation = char(datetime('now','Format','yyMMddHHmmss'));

%% Create figure
hFig = figure('WindowState','maximized');
setFigure();

%% Draw Pattern
uiwait(msgbox('Press left mouse button down and draw a pattern, to stop release the button'));
tagPatternObj = imfreehand('Closed',false);
tagPattern = tagPatternObj.getPosition;

tagPatternX = interp1(1:length(tagPattern(:,1)), tagPattern(:,1)',1:0.1:length(tagPattern(:,1)),'pchip')';
tagPatternY = interp1(1:length(tagPattern(:,2)), tagPattern(:,2)',1:0.1:length(tagPattern(:,2)),'pchip')';
tagPattern = [tagPatternX tagPatternY];
tagPatternObj.delete; clear tagPatternObj;
hp = plot(tagPattern(:,1),tagPattern(:,2));
saveData()
close all;


%% Callback functions
    function saveData(nameOut)
        if ~exist('nameOut','var')
            nameOut = '';
        end
        nameOutput =['..' filesep 'dummy_data' filesep mfilename '_'   data.DateTimeOfCreation '_' nameOut];
        set(gca,'ButtonDownFcn','')
        saveas(gcf,nameOutput)
        data.TagPositions = tagPattern;
        save(nameOutput,'data');
        uiwait(msgbox('Data is saved in a ".mat" file and the figure in a ".fig" file in the directory of this script'));
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
            set(get(get(hp(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        catch
        end
    end

end %function
