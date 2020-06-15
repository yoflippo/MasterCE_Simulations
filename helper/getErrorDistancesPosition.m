function error = getErrorDistancesPosition(anchors,measuredDistances,calculatedPositionTag)
% GETERRORDISTANCESPOSITION The difference between the distances 
% measurement and distance anchor-calculated tag position
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

% $Revisi0n: 0.0.0 $  $Date: 2020-06-11 $

% This method is used in practical situations where the real position
% (distance) is not known.
% It signifies how a solver is able to approximate the measured position of
% a tag


nA = size(anchors,1);
nT = size(measuredDistances,1);
calculatedDistances = dis(anchors,calculatedPositionTag);
if isequal(size(measuredDistances),size(calculatedDistances))
    difference = measuredDistances-calculatedDistances;
else
    difference = measuredDistances-calculatedDistances';
end
error = round((sum(difference(:).^2)/(nA*nT)),1);
end
