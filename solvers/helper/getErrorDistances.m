
function error = getErrorDistances(anchors,clean,dirty)
nA = size(anchors,1);
nT = length(clean);
distancesClean = dis(anchors,clean);
distancesDirty = dis(anchors,dirty);
difference = distancesClean-distancesDirty;
error = sum(difference(:).^2)/(nA*nT); 
end
