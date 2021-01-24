function [y,R] = getMeasurementData(signals,velocity,n,i)
% %% Pos and Vel
% y = [signals(n).sig.x(i) velocity(n).sig.x(i) ...
%     signals(n).sig.y(i) velocity(n).sig.y(i)]';
% vari = [signals(n).var(i) velocity(n).var(i)...
%     signals(n).var(i) velocity(n).var(i)]';
% R = vari.*eye(numel(vari));

y = [signals(n).sig.x(i) ...
    signals(n).sig.y(i)]';
vari = [signals(n).var(i) ...
    signals(n).var(i)]';
R = vari.*eye(numel(vari));

end