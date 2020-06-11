function error = getErrorDistances(anchors,clean,dirty)
nA = size(anchors,1);
nT = length(clean);
difference = dis(anchors,clean)-dis(anchors,dirty);
error = round((sum(difference(:).^2)/(nA*nT)),1);
end
