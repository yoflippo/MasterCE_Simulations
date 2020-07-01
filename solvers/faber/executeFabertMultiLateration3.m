function [result] = executeFabertMultiLateration3(data)
for i = 1:length(data.Distances())
    out = solver_fabert_lin(data.Distances(i,:),data.AnchorPositions);
    result(i,1:2) = out(1:2);
end
end