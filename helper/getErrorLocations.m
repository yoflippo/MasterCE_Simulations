
function error = getErrorLocations(clean,dirty)
error = round((sum(dis(clean,dirty).^2)/length(clean)),1); 
%% (distance - measured distance )^2
end
