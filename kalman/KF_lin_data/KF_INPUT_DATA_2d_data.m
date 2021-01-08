function [positionuwb,velocity,clean,temporalspecs] = KF_INPUT_DATA_2d_data()

cd(fileparts(mfilename('fullpath')));
cd('synced_measurement_data');

load('W_RANG_(~)_RS_01.mat');

t_v = wmpm.time;
dt_v = mean(diff(t_v));
n_v = numel(t_v);
fs_v = 1/dt_v;

[uwbsl, optisl] = makeSameLength(uwb,opti);
% uwbsl = improveUWB(uwbsl,100);
 
x_p = uwbsl.x;
y_p = uwbsl.y;

t_p = uwbsl.time;
dt_p = mean(diff(t_p));
n_p = numel(t_p);
fs_p = 1/dt_p;


positionuwb.x = x_p;
positionuwb.y = y_p;

R = getRotationMatrixZ(0); 
R = R(2:end,2:end);
CDR = [wmpm.coord.x wmpm.coord.y]*R;
velocity.sig.x = gradient(CDR(:,1),dt_v);
velocity.sig.y = gradient(CDR(:,2),dt_v);
% velocity.sig.x = gradient(wmpm.coord.x,dt_v);
% velocity.sig.y = gradient(wmpm.coord.y,dt_v);

clean.position.x = opti.coord.x;
clean.position.y = opti.coord.y;
dt_opti = mean(diff(opti.time));
clean.velocity.x = gradient(opti.coord.x,dt_opti);
clean.velocity.y = gradient(opti.coord.y,dt_opti);

temporalspecs.fs_v = fs_v;
temporalspecs.fs_p = fs_p;
temporalspecs.t_v = t_v;
temporalspecs.t_p = t_p;
temporalspecs.dt_v = dt_v;
temporalspecs.dt_p = dt_p;
temporalspecs.n_v = n_v;
temporalspecs.n_p = n_p;
% temporalspecs.x2 = x2;
% temporalspecs.y2 = y2;

if isequal(nargout,0)
    close all; clc;
    subplot(2,2,1);
    plot(opti.time,opti.coord.x,'DisplayName','x opti');  grid on; grid minor; hold on;
    plot(uwbsl.time,positionuwb.x,'DisplayName','x uwb'); legend(); title('Coordinates X')
    subplot(2,2,2);
    plot(opti.time,opti.coord.y,'DisplayName','y opti');grid on; grid minor; hold on;
    plot(uwbsl.time,positionuwb.y,'DisplayName','y uwb'); legend(); title('Coordinates Y')
    
    subplot(2,2,3);
    plot(t_v,velocity.sig.x,'DisplayName','vel x');  grid on; grid minor; hold on;
    plot(opti.time,clean.velocity.y,'DisplayName','vel y opti'); legend(); title('Velocity X')
    
    subplot(2,2,4);
    plot(opti.time,clean.velocity.x,'DisplayName','vel x opti'); grid on; grid minor; hold on;
    plot(t_v,velocity.sig.y,'DisplayName','vel y'); legend(); title('Velocity Y')
    %     subplot(3,1,3);
    %     plot(t,acceleration.sig.x,'DisplayName','accx');  grid on; grid minor; hold on;
    %     plot(t,acceleration.sig.y,'DisplayName','accy');
    %     covar = cov([clean.position.x clean.position.y velocity.sig.x velocity.sig.y acceleration.sig.x acceleration.sig.y])
end

end


function [uwbsl, optisl] = makeSameLength(uwb,opti)
maxTimeUwb = uwb.time(end);
maxTimeOpti = opti.time(end);
maxTimeRound = round(min(maxTimeUwb,maxTimeOpti));
vecTime = 0:1/10:max(maxTimeRound);

uwbsl.x = interp1(uwb.time,uwb.coord.x,vecTime)';
uwbsl.y = interp1(uwb.time,uwb.coord.y,vecTime)';
uwbsl.z = interp1(uwb.time,uwb.coord.z,vecTime)';
uwbsl.time = vecTime;
uwbsl = makeNaNZeroStruct(uwbsl);
optisl.x = interp1(opti.time,opti.coord.x,vecTime)';
optisl.y = interp1(opti.time,opti.coord.y,vecTime)';
optisl.z = interp1(opti.time,opti.coord.z,vecTime)';
optisl.time = vecTime;
optisl = makeNaNZeroStruct(optisl);
end


function uwb = improveUWB(uwb,varuwb)
uwb.x = filteruwb(uwb.x)+randn(size(uwb.x))*varuwb;
uwb.y = filteruwb(uwb.y)+randn(size(uwb.x))*varuwb;
% uwb.z = filteruwb(uwb.z)+randn(size(uwb.x))*varuwb;

    function vector = filteruwb(vector)
        %         [var.b,var.a] = butter(2,0.5/10,'low');
        %         vector = filtfilt(var.b,var.a,vector);
        vector = smooth(vector,5);
        vector = smooth(vector,'sgolay',2);
    end
end


% function [Signals,velocity,clean,acceleration,temporalspecs] = generateAll()
% te = 15; %sec
%
% fs = 8;
% dt = 1/fs;
% t=(0:dt:te)';
% n = numel(t);
%
% fs2 = 100;
% dt2 = 1/fs2;
% t2=(0:dt2:te)';
% n2 = numel(t2);
%
% courtwidth = 10;
% courtheigth = 10;
%
% [x,y] = eightshape_variation(t,courtwidth,courtheigth);%ground truth
% [x2,y2] = eightshape_variation(t2,courtwidth,courtheigth);
% clean.position.x = x;
% clean.position.y = y;
% clean.velocity.x = gradient(x2,dt2);
% clean.velocity.y = gradient(y2,dt2);
%
% Signals(1).var = 2*ones(size(t));
% Signals(1).sig.x = generate_signal(x, Signals(1).var);
% Signals(1).sig.y = generate_signal(y, Signals(1).var);
%
% velocity(1).var = ones(length(t2),1)*0.05;
% velocity(1).sig.x = generate_signal(clean.velocity.x, velocity(1).var);
% velocity(1).sig.y = generate_signal(clean.velocity.y, velocity(1).var);
%
% acceleration.sig.x = gradient(velocity.sig.x,dt2);
% acceleration.sig.y = gradient(velocity.sig.y,dt2);
% acceleration.var = ones(length(t),1)*2;
%
% temporalspecs.fs = fs;
% temporalspecs.fs2 = fs2;
% temporalspecs.t = t;
% temporalspecs.t2 = t2;
% temporalspecs.dt = dt;
% temporalspecs.dt2 = dt2;
% temporalspecs.n = n;
% temporalspecs.n2 = n2;
% temporalspecs.x2 = x2;
% temporalspecs.y2 = y2;
% end
%
% function [outsignal, outvar] = generate_signal(signal, var)
% noise = randn(size(signal)).*sqrt(var);
% outsignal = signal + noise;
% outvar = var;
% end


function str = makeNaNZeroStruct(str)
str.x = makeNaNZero(str.x);
str.y = makeNaNZero(str.y);
str.z = makeNaNZero(str.z);
end


function input = makeNaNZero(input)
input(isnan(input)) = 0;
end