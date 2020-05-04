function [result] = executeFabertMultiLateration9(data)
for i = 1:length(data.Distances())
    result(i,1:3) = solver_fabert_lin9(data.Distances(i,:),data.AnchorPositions);
end
end