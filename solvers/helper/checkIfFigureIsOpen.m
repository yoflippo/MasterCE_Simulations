
function res = checkIfFigureIsOpen()
% fig = get(groot,'CurrentFigure');
% if ~isempty(fig)
%     filename=strcat(fname,'_',str,'.fig');
% end
g = groot;
isempty(g.Children)