function [z,R] = UKF_get_measurement_sample(position,velocity,n,i,boolPosition,boolInit)
if not(exist('boolPosition','var'))
    boolPosition = false;
end
if not(exist('boolInit','var'))
    boolInit = false;
end

if boolInit
    z = [position(n).x(i) position(n).y(i) ...
        velocity(n).res(i) velocity(n).angularRate(i) ...
        initAngleBasedOnUWB(position)]';
    
    vari = [ position(n).var(i) position(n).var(i) ...
        velocity(n).var(i) velocity(n).varAngles(i) ...
        10]';
else
    if not(boolPosition)
        z = [velocity(n).res(i) velocity(n).angularRate(i)]';
        vari = [velocity(n).var(i) velocity(n).varAngles(i)]';
    else
        z = [position(n).x(i) position(n).y(i) ]';
        vari = [position(n).var(i) position(n).var(i) ]';
    end
end

R = vari.*eye(numel(vari));
end

function angle = initAngleBasedOnUWB(position)
w = 3;
pos1.x = mean(position.x(1:w));
pos1.y = mean(position.y(1:w));
pos2.x = mean(position.x(w+1:(2*w)+1));
pos2.y = mean(position.y(w+1:(2*w)+1));
angle = atan2d(pos2.x-pos1.x,pos2.y-pos1.y);
end