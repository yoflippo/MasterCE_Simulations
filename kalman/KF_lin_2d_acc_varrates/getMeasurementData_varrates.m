function [y,R] = getMeasurementData_varrates(signals,velocity,n,i,boolPos)
if not(exist('boolPos','var'))
    boolPos = false;
end

if not(boolPos)
    y = [velocity(n).sig.x(i) ...
        velocity(n).sig.y(i)]';
    
    vari = [velocity(n).var(i)...
        velocity(n).var(i)]';
else
    y = [signals(n).sig.x(i) ...
        signals(n).sig.y(i) ]';
    
    vari = [signals(n).var(i)  ...
        signals(n).var(i) ]';
end

if i == 1 && not(boolPos)
    y = [signals(n).sig.x(i) velocity(n).sig.x(i) ...
        signals(n).sig.y(i) velocity(n).sig.y(i)]';
    
    vari = [signals(n).var(i) velocity(n).var(i) ...
        signals(n).var(i) velocity(n).var(i)]';
end

R = vari.*eye(numel(vari));
end