function [result] = executeFabertMultiLateration2(data)
for i = 1:length(data.Distances())
    out = solver_fabert_lin2(data.Distances(i,:),data.AnchorPositions);
    result(i,1:2) = out(1:2);
end
end