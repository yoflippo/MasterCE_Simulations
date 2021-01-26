function [y,R] = UKF_lin_get_measurement_sample(position,velocity,n,i,boolPosition)
if not(exist('boolPosition','var'))
    boolPosition = false;
end

if not(boolPosition)
    y = [velocity(n).x(i) ...
        velocity(n).y(i)]';
    
    vari = [velocity(n).var(i)...
        velocity(n).var(i)]';
else
    y = [position(n).x(i) ...
        position(n).y(i) ]';
    
    vari = [position(n).var(i)  ...
        position(n).var(i) ]';
end

R = vari.*eye(numel(vari));
end