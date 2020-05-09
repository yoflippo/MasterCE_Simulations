function [result] = executeFabertMultiLateration2b(data)
for i = 1:length(data.Distances())
    result(i,1:3) = solver_fabert_lin2b(data.Distances(i,:),data.AnchorPositions);
end
end