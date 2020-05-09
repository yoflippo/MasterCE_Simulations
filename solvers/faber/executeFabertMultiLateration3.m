function [result] = executeFabertMultiLateration3(data)
for i = 1:length(data.Distances())
    result(i,1:3) = solver_fabert_lin3(data.Distances(i,:),data.AnchorPositions);
end
end