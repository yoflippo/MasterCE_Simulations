function [position,velocity,acceleration,clean,temporalspecs] = UKF_create_simulation_data(blRenewData)
if not(exist('blRenewData','var'))
    blRenewData = false;
end

matfilename = [mfilename '.mat'];
cd(fileparts(mfilename('fullpath')));
if not(exist(matfilename,'file')) || blRenewData
    [position,velocity,acceleration,clean,temporalspecs] = generateAll();
    save(matfilename);
else
    load(matfilename);
    [position2,velocity2,acceleration2,clean2,temporalspecs2] = generateAll();
    if (not(isequal(clean.position,clean2.position)) || ...
            not(isequal(clean.velocity,clean2.velocity)) || ...
            not(isequal(position.var,position2.var)) || ...
            not(isequal(temporalspecs2.fs,temporalspecs.fs)) || ...
            not(isequal(position2.rotatedoffset,position.rotatedoffset)) || ...
            not(isequal(acceleration2.var,acceleration.var)) || ...
            not(isequal(temporalspecs2.fs2,temporalspecs.fs2)) || ...
            not(isequal(temporalspecs2.n,temporalspecs.n)) || ...
            not(isequal(temporalspecs2.n2,temporalspecs.n2)) || ...
            not(isequal(velocity.varAngles,velocity2.varAngles)) || ...
            not(isequal(velocity.var,velocity2.var)))
        clear position2 clean2 velocity2 acceleration2 temporalspecs2
        [position,velocity,acceleration,clean,temporalspecs] = generateAll();
        save(matfilename);
    end
    clear Signals2 clean2 velocity2 acceleration2 temporalspecs2
end

if isequal(nargout,0)
    close all; clc;
    t = temporalspecs.t;
    t2 = temporalspecs.t2;
    t3 = temporalspecs.t3;
    figure('units','normalized','outerposition',[0.1 0.1 0.7 0.7])
    
    subplot(4,4,[1 2]);
    plot(t,clean.position.x,'DisplayName','x'); hold on;
    plot(t,position.xSavitskyGolay, 'DisplayName','x-Savitsky-Golay');
    plot(t3,position.xSgolayUpsampled, 'DisplayName','x-Savitsky-Golay Upsampled');
    grid on; grid minor; title('x'); legend
    
    subplot(4,4,[5 6]);
    plot(t,clean.position.y,'DisplayName','y');  hold on;
    plot(t,position.ySavitskyGolay, 'DisplayName','y-Savitsky-Golay');
    plot(t3,position.ySgolayUpsampled, 'DisplayName','y-Savitsky-Golay Upsampled');
    grid on; grid minor; title('y'); legend
    
    subplot(4,4,[9 10]);
    plot(t2,velocity.x,'DisplayName','velx');   hold on;
    plot(t2,velocity.y,'DisplayName','vely');
    plot(t2,velocity.res,'DisplayName','vel RES');  
    grid on; grid minor; title('velocity x/y');
    
    subplot(4,4,[13 14]);
    plot(t2,acceleration.x,'DisplayName','accx');  grid on; grid minor; hold on;
    plot(t2,acceleration.y,'DisplayName','accy');
    plot(t2,acceleration.res,'DisplayName','acc RES'); title('acceleration');
    
    subplot(4,4,[3 4 7 8 11 12]);
    plot(clean.position.x,clean.position.y,'DisplayName','x-y clean'); hold on;
    plot(position.x,position.y,'DisplayName','x-y UWB');
    plot(position.xSavitskyGolay,position.ySavitskyGolay, 'DisplayName','x-y-Savitsky-Golay');
    plot(position.xSgolayUpsampled,position.ySgolayUpsampled, 'DisplayName','x-y-Savitsky-Golay Upsampled');
    title('x-y'); grid on; grid minor; legend
    axis equal;
    
    subplot(4,4,[15 16]);
    plot(t2,velocity.angularRate);  grid on; grid minor; hold on; title('Angular rate');
end

end

function [position,velocity,acceleration,clean,tspecs] = generateAll()
te = 15; %sec
courtwidth = 10;
courtheigth = 20;

fs = 7;  % position
fs2 = 100; % velocity

[~,t,~] = createTemporalSpecs(fs,te);
[xrot,yrot,x,y] = rotateAndAddOffset(t,courtwidth,courtheigth);%ground truth

clean.position.x = x;
clean.position.y = y;

% [dt,t,n] = addJitter(fs,te);
% [dt2,t2,n2] = addJitter(fs2,te);
[dt,t,n] = createTemporalSpecs(fs,te);
[dt2,t2,n2] = createTemporalSpecs(fs2,te);

position.var = 2;
position.x = generate_signal(x, position.var);
position.y = generate_signal(y, position.var);
sgolayN = 1;

position.xSavitskyGolay = smooth(position.x,'sgolay',sgolayN);
position.ySavitskyGolay = smooth(position.y,'sgolay',sgolayN);

fs3 = fs*4;
[position.xSgolayUpsampled,position.ySgolayUpsampled] = increaseSampleRate(fs3,t,position.xSavitskyGolay,position.ySavitskyGolay);
position.xSgolayUpsampled = generate_signal(position.xSgolayUpsampled,0.2);
position.ySgolayUpsampled = generate_signal(position.ySgolayUpsampled,0.2);
[dt3,t3,n3] = createTemporalSpecs(fs3,te);


[x2rot,y2rot,x2,y2] = rotateAndAddOffset(t2,courtwidth,courtheigth);
position.rotatedoffset.x = x2rot;
position.rotatedoffset.y = y2rot;
position.x2 = x2;
position.y2 = y2;

clean.velocity.x = gradient(x2rot,dt2);
clean.velocity.y = gradient(y2rot,dt2);
clean.velocity.res =  sqrt(clean.velocity.x.^2 + clean.velocity.y.^2);
% clean.velocity.res = clean.velocity.res + simulate_slipping(t2);

velocity.var = 0.1;
velocity.x = generate_signal(clean.velocity.x, velocity.var); %rotated
velocity.y = generate_signal(clean.velocity.y, velocity.var); %rotated
velocity.res = generate_signal(clean.velocity.res, velocity.var);

clean.velocity.angularRate = calculateAnglesBetweenXYpoints(x2rot,y2rot,dt2);
clean.velocity.angles = cumtrapz(t2,clean.velocity.angularRate);

velocity.varAngles = 20;
velocity.angularRate = generate_signal(clean.velocity.angularRate,velocity.varAngles);
velocity.angles = cumtrapz(t2,velocity.angularRate);

acceleration.var = ones(length(t2),1)*2;
acceleration.x = gradient(velocity.x,dt2);
acceleration.y = gradient(velocity.y,dt2);
acceleration.res = gradient(velocity.res,dt2);

tspecs.fs = fs;
tspecs.fs2 = fs2;
tspecs.fs3 = fs3;

tspecs.t = t;
tspecs.t2 = t2;
tspecs.t3 = t3;

tspecs.dt = dt;
tspecs.dt2 = dt2;
tspecs.dt3 = dt3;

tspecs.n = n;
tspecs.n2 = n2;
tspecs.n3 = n3;
end


function [outsignal, outvar] = generate_signal(signal, var)
noise = randn(size(signal))*sqrt(var);
outsignal = signal + noise;
outvar = var;
end


function [x,y] = increaseSampleRate(fsNew,t,x,y)
maxTimeUwb = t(end);
vecTime = 0:1/fsNew:maxTimeUwb;
x = interp1(t,x,vecTime')';
y = interp1(t,y,vecTime')';
end

function [dt,t,n] = createTemporalSpecs(samplerate,durationSeconds)
dt = 1/samplerate;
t=(0:dt:durationSeconds)';
n = numel(t);
end


function [dt,t,n] = addJitter(samplerate,durationSeconds)
[dt,t,n] = createTemporalSpecs(samplerate,durationSeconds);
t(2:end-1) = t(2:end-1) + abs(randn(size(t(2:end-1)))*dt/10);
end


function angularRate = calculateAnglesBetweenXYpoints(x,y,dt)
angularRate = calculateAngleBasedOn3Points(x,y)/dt;
angularRate = [0; 0; angularRate];

% drawToTestAngles(angles,dt,x,y)

    function angles = calculateAngleBasedOn3Points(vectorX,vectorY)
        for n = 1:length(vectorX)-2
            point1 = [vectorX(n) vectorY(n)];
            point2 = [vectorX(n+1) vectorY(n+1)];
            point3 = [vectorX(n+2) vectorY(n+2)];
            vector1 = point2 - point1;
            vector2 = point3 - point2;
            if isLeft(point1,point2,point3)
                angles(n,1) = angleBetweenVectors(vector1,vector2);
            else
                angles(n,1) = -angleBetweenVectors(vector2,vector1);
            end
        end
    end

    function drawToTestAngles(angularRate,dt,x,y)
        close all;
        figure('units','normalized','outerposition',[0.1 0.1 0.8 0.8])
        %         angularRate = gradient(angles,dt);
        Angles = cumtrapz(angularRate);
        idx = findZeroCrossings(angularRate);
        subplot(3,2,1); plot(x); hold on; plot(y); title('positions');
        scatterNiceColors(idx,x(idx)); scatterNiceColors(idx,y(idx));
        grid on;
        
        subplot(3,2,[3 4]); plot(Angles); title('angle');
        grid on; hold on;
        scatterNiceColors(idx,Angles(idx))
        
        subplot(3,2,[5 6]); plot(angularRate); title('angular rate');
        grid on; hold on;
        scatterNiceColors(idx,angularRate(idx))
        
        subplot(3,2,2); plot(x,y); title('x-y'); hold on;
        scatterNiceColors(x(idx),y(idx))
        grid on; axis equal;
        pause
    end
end


function [xrot,yrot,x,y] = rotateAndAddOffset(t,courtwidth,courtheigth)
R = getRotationMatrixZ(130);
R = R(2:end,2:end);
[x,y] = eightshape_variation(t,courtwidth,courtheigth);
randomOffset = 10;
CDR = ([x y]+randomOffset)*R;
xrot = CDR(:,1);
yrot = CDR(:,2);
end