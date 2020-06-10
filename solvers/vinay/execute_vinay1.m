function [result] = execute_vinay1(data)
for i = 1:length(data.distances())
    result(i,1:2) = solver_vinay_1(data.distances(i,:),data.anchorpos);
end
end