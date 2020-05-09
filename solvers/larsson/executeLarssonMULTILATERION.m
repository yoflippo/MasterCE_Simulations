function [A] = executeLarssonMULTILATERION(data)
for i = 1:length(data.Distances())
%     result(i,1:2) = 
    A = solver_optmultlat(data.AnchorPositions',data.Distances(i,:))';
end
end
