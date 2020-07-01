function [result] = executeFabertMultiLateration4a(data)
for i = 1:length(data.Distances())
    result(i,1:2) = solver_fabert_lin41(data.Distances(i,:),data.AnchorPositions);
end
end