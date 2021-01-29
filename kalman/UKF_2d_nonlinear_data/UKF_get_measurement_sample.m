function [z,R] = UKF_get_measurement_sample(position,velocity,acceleration,i,boolPosition,boolInit)
if not(exist('boolPosition','var'))
    boolPosition = false;
end
if not(exist('boolInit','var'))
    boolInit = false;
end

varianceAngularRate = 0.01;

if boolInit
    z = [position.x(i) position.y(i) ...
        velocity.res(i) velocity.angularRate(i) ...
        initAngleBasedOnUWB(position)]';
    
    vari = [1 1 0.1 0.1 10]';
else
    if not(boolPosition)
        z = [ velocity.angularRate(i) velocity.res(i)]';
        vari = [0.01 0.1]';
    else
        z = [position.x(i) position.y(i)  ]';
        vari = ones(2,1)*10;
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