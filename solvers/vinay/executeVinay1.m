function [result] = executeVinay1(data)
for i = 1:length(data.Distances())
    result(i,1:2) = solver_murphy_1(data.Distances(i,1:3),data.AnchorPositions(1:3,1:2))';
end