function [result] = executeFabertMultiLateration4b(data)
for i = 1:length(data.Distances())
    result(i,1:2) = solver_fabert_lin42(data.Distances(i,:),data.AnchorPositions);
end
end