function error = getErrorDistances(anchors,PosClean,PosDirty)
nA = size(anchors,1);
nT = length(PosClean);
difference = dis(anchors,PosClean)-dis(anchors,PosDirty);
error = round((sum(difference(:).^2)/(nA*nT)),1);-am
end
