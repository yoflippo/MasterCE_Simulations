function [positionuwb,velocity,clean,temporalspecs] = KF_INPUT_DATA_2d_data()

cd(fileparts(mfilename('fullpath')));
cd('synced_measurement_data');

load('W_RANG_(~)_RS_00.mat');

t_v = wmpm.time;
dt_v = mean(diff(t_v));
n_v = numel(t_v);
fs_v = 1/dt_v;

x_p = uwb.coord.x;
y_p = uwb.coord.y;

t_p = uwb.time;
dt_p = mean(diff(t_p));
n_p = numel(t_p);
fs_p = 1/dt_p;

positionuwb.x = x_p;
positionuwb.y = y_p;

velocity.sig.x = gradient(wmpm.coord.x,dt_v);
velocity.sig.y = gradient(wmpm.coord.y,dt_v);

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
    plot(uwb.time,uwb.coord.x,'DisplayName','x uwb'); legend(); title('Coordinates X')
    subplot(2,2,2);
    plot(opti.time,opti.coord.y,'DisplayName','y opti');grid on; grid minor; hold on;
    plot(uwb.time,uwb.coord.y,'DisplayName','y uwb'); legend(); title('Coordinates Y')
    
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