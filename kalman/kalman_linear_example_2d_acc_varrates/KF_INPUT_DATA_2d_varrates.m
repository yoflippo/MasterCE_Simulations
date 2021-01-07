function [Signals,velocity,clean,acceleration,temporalspecs] = KF_INPUT_DATA_2d_varrates()
matfilename = [mfilename '.mat'];
cd(fileparts(mfilename('fullpath')));
if not(exist(matfilename,'file'))
    [Signals,velocity,clean,acceleration,temporalspecs] = generateAll();
    save(matfilename);
else
    load(matfilename);
    [Signals2,velocity2,clean2,acceleration2,temporalspecs2] = generateAll();
    if (not(isequal(clean.position.x,clean2.position.x)) || ...
            not(isequal(Signals(1).var,Signals2(1).var)) || ...
            not(isequal(temporalspecs2,temporalspecs)) || ...
            not(isequal(velocity(1).var,velocity2(1).var)))
        [Signals,velocity,clean,acceleration,temporalspecs] = generateAll();
        clear Signals2 clean2 velocity2 acceleration2 temporalspecs2
        save(matfilename);
    end
    clear Signals2 clean2 velocity2 acceleration2 temporalspecs2
end

if isequal(nargout,0)
    close all; clc;
    subplot(3,1,1);
    plot(t,clean.position.x,'DisplayName','x');  grid on; grid minor; hold on;
    plot(t,clean.position.y,'DisplayName','y');
    
    subplot(3,1,2);
    plot(t,velocity.sig.x,'DisplayName','velx');  grid on; grid minor; hold on;
    plot(t,velocity.sig.y,'DisplayName','vely');
    
    subplot(3,1,3);
    plot(t,acceleration.sig.x,'DisplayName','accx');  grid on; grid minor; hold on;
    plot(t,acceleration.sig.y,'DisplayName','accy');
    covar = cov([clean.position.x clean.position.y velocity.sig.x velocity.sig.y acceleration.sig.x acceleration.sig.y])
end

end

function [Signals,velocity,clean,acceleration,temporalspecs] = generateAll()
te = 15; %sec

fs = 9;
dt = 1/fs;
t=(0:dt:te)';
n = numel(t);

fs2 = 100;
dt2 = 1/fs2;
t2=(0:dt2:te)';
n2 = numel(t2);

courtwidth = 10;
courtheigth = 10;

[x,y] = eightshape_with_variation(t,courtwidth,courtheigth);%ground truth
[x2,y2] = eightshape_with_variation(t2,courtwidth,courtheigth);
clean.position.x = x;
clean.position.y = y;
clean.velocity.x = gradient(x2,dt2);
clean.velocity.y = gradient(y2,dt2);

Signals(1).var = 1*ones(size(t));
Signals(1).sig.x = generate_signal(x, Signals(1).var);
Signals(1).sig.y = generate_signal(y, Signals(1).var);

velocity(1).var = ones(length(t2),1)*0.05;
velocity(1).sig.x = generate_signal(clean.velocity.x, velocity(1).var);
velocity(1).sig.y = generate_signal(clean.velocity.y, velocity(1).var);

acceleration.sig.x = gradient(velocity.sig.x,dt2);
acceleration.sig.y = gradient(velocity.sig.y,dt2);
acceleration.var = ones(length(t),1)*2;

temporalspecs.fs = fs;
temporalspecs.fs2 = fs2;
temporalspecs.t = t;
temporalspecs.t2 = t2;
temporalspecs.dt = dt;
temporalspecs.dt2 = dt2;
temporalspecs.n = n;
temporalspecs.n2 = n2;
temporalspecs.x2 = x2;
temporalspecs.y2 = y2;
end

function [outsignal, outvar] = generate_signal(signal, var)
noise = randn(size(signal)).*sqrt(var);
outsignal = signal + noise;
outvar = var;
end