function [result] = executeFabertMultiLateration2(data)
for i = 1:length(data.Distances())
    result(i,1:3) = solver_fabert_lin2(data.Distances(i,:),data.AnchorPositions);
end
end