function [result] = executeFabertMultiLateration2a(data)
for i = 1:length(data.Distances())
    result(i,1:3) = solver_fabert_lin2a(data.Distances(i,:),data.AnchorPositions);
end
end