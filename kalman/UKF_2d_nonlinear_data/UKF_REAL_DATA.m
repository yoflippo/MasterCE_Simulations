function [position,velocity,clean,temporalspecs] = UKF_REAL_DATA(ap)
apfullpath = fileparts(mfilename('fullpath'));
cd(apfullpath);
apsynced = findSubFolderPath(apfullpath,'MATLAB','synced');
cd(apsynced);

if not(exist('ap','var')) || isempty(ap)
    load('W_RANG_(~)_RS_00.mat');
else
    load(ap);
end


[uwb,opti,wmpm] = cutSynchronizationPartofMeasurementOff(uwb,opti,wmpm);

[uwb, opti] = makeSameLength(uwb,opti);

t = uwb.time;
dt = mean(diff(t));
n = numel(t);
fs = 1/dt;

t2 = wmpm.time;
dt2 = mean(diff(t2));
n2 = numel(t2);
fs2 = 1/dt2;

position.xDownSampledOpti = opti.xDownSampled;
position.yDownSampledOpti = opti.yDownSampled;

position.x = uwb.x;
position.y = uwb.y;

clean.position.x = opti.coord.x;
clean.position.y = opti.coord.y;
clean.position.time = opti.time;

clean.velocity.x = gradient(clean.position.x,dt2);
clean.velocity.y = gradient(clean.position.y,dt2);
clean.velocity.res = gradient(sqrt((clean.position.x.^2) + (clean.position.y.^2)),dt2);

velocity.res = wmpm.velframe*1000;
velocity.angularRate = wmpm.angularRate;
% clean.velocity.angularRate = calculateAnglesBetweenXYpoints(opti.coord.x,opti.coord.y,dt2);

temporalspecs.fs2  = fs2;
temporalspecs.fs  = fs;
temporalspecs.t2   = t2;
temporalspecs.t   = t;
temporalspecs.dt2  = dt2;
temporalspecs.dt  = dt;
temporalspecs.n2   = n2;
temporalspecs.n   = n;


if isequal(nargout,0)
    close all; clc;
    subplot(4,1,1);
    plot(clean.position.time,clean.position.x,'DisplayName','x opti');  grid on; grid minor; hold on;
    plot(uwb.time,position.x,'DisplayName','x uwb'); legend(); title('Coordinates X')
    
    subplot(4,1,2);
    plot(clean.position.time,clean.position.y,'DisplayName','y opti');grid on; grid minor; hold on;
    plot(uwb.time,position.y,'DisplayName','y uwb'); legend(); title('Coordinates Y')
    
    subplot(4,1,3);
    plot(wmpm.time,velocity.res,'DisplayName','res. vel. WMPM');  grid on; grid minor; hold on;
    plot(clean.position.time,clean.velocity.res,'DisplayName','res. vel. OPTI'); legend(); title('Resultant velocities')
    
    subplot(4,1,4);
    plot(wmpm.time,velocity.angularRate,'DisplayName','res. vel. WMPM');  grid on; grid minor; hold on;
    %     plot(clean.position.time,clean.velocity.res,'DisplayName','res. vel. OPTI');
    legend(); title('Angularrate')
end
end


function [uwb,opti,wmpm] = cutSynchronizationPartofMeasurementOff(uwb,opti,wmpm)
uwb = cutDirtySyncOff(uwb);
opti = cutDirtySyncOff(opti);
wmpm = cutDirtySyncOff(wmpm);

idxsWMPM = wmpm.cleanSignalTimeIdx(1):wmpm.cleanSignalTimeIdx(2);
wmpm.velframe = wmpm.velframe(idxsWMPM);
wmpm.angularRate = wmpm.angularRate(idxsWMPM);

    function sData = cutDirtySyncOff(sData)
        Idxs = sData.cleanSignalTimeIdx(1):sData.cleanSignalTimeIdx(2);
        sData.time = sData.time(Idxs);
        sData.time = sData.time - sData.time(1);
        sData.coord.x = sData.coord.x(Idxs);
        sData.coord.y = sData.coord.y(Idxs);
    end
end


function [uwb, opti] = makeSameLength(uwb,opti)
maxTimeUwb = uwb.time(end);
maxTimeOpti = opti.time(end);
maxTimeRound = round(min(maxTimeUwb,maxTimeOpti));
vecTime = 0:1/10:max(maxTimeRound);

uwb.x = interp1(uwb.time,uwb.coord.x,vecTime)';
uwb.y = interp1(uwb.time,uwb.coord.y,vecTime)';
uwb.time = vecTime;

opti.xDownSampled = interp1(opti.time,opti.coord.x,vecTime)';
opti.yDownSampled = interp1(opti.time,opti.coord.y,vecTime)';
opti.timeDownSampled = vecTime;
end


function uwb = improveUWB(uwb,varuwb)
uwb.x = filteruwb(uwb.x)+randn(size(uwb.x))*varuwb;
uwb.y = filteruwb(uwb.y)+randn(size(uwb.x))*varuwb;
    function vector = filteruwb(vector)
        %         [var.b,var.a] = butter(2,0.5/10,'low');
        %         vector = filtfilt(var.b,var.a,vector);
        vector = smooth(vector,5);
        vector = smooth(vector,'sgolay',2);
    end
end


function str = makeNaNZeroStruct(str)
str.x = makeNaNZero(str.x);
str.y = makeNaNZero(str.y);
end


function input = makeNaNZero(input)
input(isnan(input)) = 0;
end


function angularRate = calculateAnglesBetweenXYpoints(x,y,dt)
angularRate = calculateAngleBasedOn3Points(x,y)/dt;
angularRate = [0; 0; angularRate];

drawToTestAngles(angularRate,dt,x,y)

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