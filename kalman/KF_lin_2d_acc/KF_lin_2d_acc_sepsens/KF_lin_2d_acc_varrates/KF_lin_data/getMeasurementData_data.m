function [y,R] = getMeasurementData_data(signals,velocity,n,i,boolPos)
if not(exist('boolPos','var'))
    boolPos = false;
end

var_uwb = 500;
var_wmpm = 10;

if not(boolPos)
    y = [velocity.sig.x(i) ...
        velocity.sig.y(i)]';
    vari = var_wmpm;
else
    y = [signals(n).x(i) ...
        signals(n).y(i) ]';
    vari = var_uwb;
end

if i == 1 && not(boolPos)
    y = [signals(n).x(i) velocity.sig.x(i) ...
        signals(n).y(i) velocity.sig.y(i)]';
    vari = [var_uwb var_wmpm ...
        var_uwb var_wmpm]';
end

R = vari.*eye(numel(vari));
end