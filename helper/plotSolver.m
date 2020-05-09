
function plotSolver(fn,result,markerColor,markerType,displayName,lineWidth)
if ~exist('markerColor','var')
    markerColor = 'g';
end
if ~exist('markerType','var')
    markerType = 'x';
end
if ~exist('displayName','var')
    displayName = '';
end
if ~exist('lineWidth','var')
    lineWidth = 1;
end

nameFigure = [replace(fn,'.mat','') '.fig'];
[~, figFileNameFigureToOpen] = fileparts(nameFigure);

figH = get(groot,'CurrentFigure');
figFileNameCurrent = '';
if ~isempty(figH)
    [~, figFileNameCurrent] = fileparts(figH.FileName);
end

if ~isequal(figFileNameFigureToOpen,figFileNameCurrent)
    open(nameFigure);
end

hold on;
plot(result(:,1),result(:,2),markerType,'MarkerSize',6, ...
    'MarkerEdgeColor',markerColor, ...
    'LineWidth',lineWidth, ...
    'DisplayName',displayName);
end

