function [z,R] = UKF_get_measurement_sample(position,velocity,acceleration,i,boolPosition,boolInit)
if not(exist('boolPosition','var'))
    boolPosition = false;
end
if not(exist('boolInit','var'))
    boolInit = false;
end

varianceAngularRate = 0.01;
boolUseUpsampling = false;
boolUseSavitsky = false;

if boolInit
    if boolUseUpsampling
        z = [position.savitskygolayUpsamp.x(i) position.savitskygolayUpsamp.y(i) ...
            velocity.res(i) velocity.angularRate(i) ...
            initAngleBasedOnUWB(position)]';
        
        vari = [ position.var.savitskygolay  position.var.savitskygolay  ...
            velocity.var.vel varianceAngularRate 10]';
    else
        if boolUseSavitsky
            z = [position.savitskygolay.x(i) position.savitskygolay.y(i) ...
                velocity.res(i) velocity.angularRate(i) ...
                initAngleBasedOnUWB(position)]';
        else
            z = [position.x(i) position.y(i) ...
                velocity.res(i) velocity.angularRate(i) ...
                initAngleBasedOnUWB(position)]';
        end
        
        vari = [ position.var.pos position.var.pos ...
            velocity.var.vel varianceAngularRate 10]';
    end
else
    if not(boolPosition)
        z = [ velocity.angularRate(i) velocity.res(i)]';
        vari = [varianceAngularRate velocity.var.vel ]';
    else
        if boolUseUpsampling
            z = [position.savitskygolayUpsamp.x(i) position.savitskygolayUpsamp.y(i)]';
            vari = [position.var.savitskygolay  position.var.savitskygolay  ]';
        else
            if  boolUseSavitsky
                z = [position.savitskygolay.x(i) position.savitskygolay.y(i)]';
                vari = [position.var.pos position.var.pos ]';
            else
                z = [position.x(i) position.y(i)  ]';
                vari = [position.var.pos position.var.pos ]';
            end
        end
    end
end

R = vari.*eye(numel(vari));
end

function angle = initAngleBasedOnUWB(position)
w = 2;
pos1.x = mean(position.x(1:w));
pos1.y = mean(position.y(1:w));
pos2.x = mean(position.x(w+1:(2*w)+1));
pos2.y = mean(position.y(w+1:(2*w)+1));
angle = atan2d(pos2.x-pos1.x,pos2.y-pos1.y);
end