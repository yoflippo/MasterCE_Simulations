function [result] = execute_vinay1(data)
for i = 1:length(data.Distances())
    result(i,1:2) = solver_vinay_1(data.Distances(i,:),data.AnchorPositions);
end
end