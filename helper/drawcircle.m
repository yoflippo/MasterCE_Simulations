function h = drawcircle(x,y,rad,color,lineth,centresymbol)
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
% DESCRIPTION:
%
% 
% BY: 2020  M. Schrauwen (markschrauwen@gmail.com)
% 
% PARAMETERS:
% * optional
%               x:   x-coordinate
%               y:   y-coordinate
%               rad*:   radius of circle
%               color*:      color of circle according MATLAB color naming
%                           convention
%               lineth*: Line Thickness (whole natural number)
%
% RETURN:       
%               h: handle of figure.  
% 
% EXAMPLES:
%
%

% $Revision: 0.0.0 $  $Date: 2020-03-02 $
% Creation of this function.


if not(exist('rad','var'))
    rad = 3;
end
if not(exist('lineth','var'))
    lw = 1;
else
    lw = lineth;
end
if not(exist('centresymbol','var'))
   centresymbol = '^'; 
end

p = 0:pi/100:2*pi;
xcor = rad * cos(p) + x;
ycor = rad * sin(p) + y;

if not(exist('color','var'))
    h = plot(xcor, ycor,'Linewidth',lw);
    hold on;
    h = plot(x,y,'^','Linewidth',round(lw/2),'MarkerSize',20);
else
    h = plot(xcor, ycor,'Color',color,'Linewidth',lw);
    hold on;
    h = plot(x,y,'Color','b','Marker',centresymbol,'Linewidth',3,'MarkerSize',10); 
end
axis equal
end %function
