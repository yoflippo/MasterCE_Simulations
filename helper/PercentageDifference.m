function outVar = PercentageDifference(num1,num2)
% PROCENTUALDIFFERENCE 
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

% $Revision: 0.0.0 $  $Date: 2020-05-03 $
% Creation of this function.

outVar = 100*((num1(:)-num2(:)) ./ mean([num2(:) num1(:)]')');
if size(num1) ~= size(outVar)
    outVar = outVar';
end
end %function