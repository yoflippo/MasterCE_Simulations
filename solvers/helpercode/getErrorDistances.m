function [error,differenceVector] = getErrorDistances(AnchorPos,CleanTagPos,CalculatedTagPos)
nA = size(AnchorPos,1);
nT = length(CleanTagPos);
differenceVector = dis(AnchorPos,CleanTagPos)-dis(AnchorPos,CalculatedTagPos);
error = sqrt((sum(differenceVector(:).^2)/(nA*nT)));
end
