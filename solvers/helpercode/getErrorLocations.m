function error = getErrorLocations(CleanPositions,DirtyPositions)
error = sqrt((sum(dis(CleanPositions,DirtyPositions).^2)/length(CleanPositions))); 
end
