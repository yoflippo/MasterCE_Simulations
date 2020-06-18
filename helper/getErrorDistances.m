function error = getErrorDistances(AnchorPos,CleanTagPos,CalculatedTagPos)
nA = size(AnchorPos,1);
nT = length(CleanTagPos);
difference = dis(AnchorPos,CleanTagPos)-dis(AnchorPos,CalculatedTagPos);
error = round((sum(difference(:).^2)/(nA*nT)),1);
end
