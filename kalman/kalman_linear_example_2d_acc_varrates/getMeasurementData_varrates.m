function [y,R] = getMeasurementData_varrates(signals,velocity,n,i)
y = [signals(n).sig.x(i) velocity(n).sig.x(i) ...
    signals(n).sig.y(i) velocity(n).sig.y(i)]';

vari = [signals(n).var(i) velocity(n).var(i)...
    signals(n).var(i) velocity(n).var(i)]';

R = vari.*eye(numel(vari));
end