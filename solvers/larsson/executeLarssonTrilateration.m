function [result] = executeLarssonTrilateration(data)
for i = 1:length(data.Distances())
    result(i,1:2) = solver_opttrilat(data.AnchorPositions',data.Distances(i,:))';
end
end
