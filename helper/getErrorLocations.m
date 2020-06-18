function error = getErrorLocations(CleanPositions,DirtyPositions)
error = round((sum(dis(CleanPositions,DirtyPositions).^2)/length(CleanPositions)),1); 
end
