function [position,velocity,clean,acceleration,temporalspecs] = UKF_lin_create_simulation_data(blRenewData)
if not(exist('blRenewData','var'))
    blRenewData = false;
end

matfilename = [mfilename '.mat'];
cd(fileparts(mfilename('fullpath')));
if not(exist(matfilename,'file')) || blRenewData
    [position,velocity,clean,acceleration,temporalspecs] = generateAll();
    save(matfilename);
else
    load(matfilename);
    [Signals2,velocity2,clean2,acceleration2,temporalspecs2] = generateAll();
    if (not(isequal(clean.position,clean2.position)) || ...
            not(isequal(position.var,Signals2.var)) || ...
            not(isequal(temporalspecs2.fs,temporalspecs.fs)) || ...
            not(isequal(temporalspecs2.fs2,temporalspecs.fs2)) || ...
            not(isequal(temporalspecs2.n,temporalspecs.n)) || ...
            not(isequal(temporalspecs2.n2,temporalspecs.n2)) || ...
            not(isequal(velocity.var,velocity2.var)))
        clear Signals2 clean2 velocity2 acceleration2 temporalspecs2
        [position,velocity,clean,acceleration,temporalspecs] = generateAll();
        save(matfilename);
    end
    clear Signals2 clean2 velocity2 acceleration2 temporalspecs2
end

if isequal(nargout,0)
    close all; clc;
    t = temporalspecs.t;
    t2 = temporalspecs.t2;
    figure('units','normalized','outerposition',[0.1 0.1 0.7 0.7])
    subplot(3,2,1);
    plot(t,clean.position.x,'DisplayName','x');  grid on; grid minor; hold on;
    plot(t,clean.position.y,'DisplayName','y'); title('xy & xy rotated');
    
    plot(t2,position.rotatedoffset.x,'DisplayName','x rotated offset');
    plot(t2,position.rotatedoffset.y,'DisplayName','y rotated offset');
    
    subplot(3,2,3);
    plot(t2,velocity.x,'DisplayName','velx');  grid on; grid minor; hold on;
    plot(t2,velocity.y,'DisplayName','vely');
    plot(t2,velocity.res,'DisplayName','vel RES');  title('velocity x/y');
    
    subplot(3,2,5);
    plot(t2,acceleration.x,'DisplayName','accx');  grid on; grid minor; hold on;
    plot(t2,acceleration.y,'DisplayName','accy');
    plot(t2,acceleration.res,'DisplayName','acc RES'); title('acceleration');
    
    subplot(3,2,[2 4 6]);
    plot(clean.position.x,clean.position.y);  grid on; grid minor; hold on;
    plot(position.rotatedoffset.x,position.rotatedoffset.y);
    plot(position.x,position.y); axis equal; title('x-y');
end

end


function [position,velocity,clean,acceleration,temporalspecs] = generateAll()
te = 15; %sec
courtwidth = 10;
courtheigth = 20;

fs = 10;  % position
fs2 = 100; % velocity

[~,t,~] = createTemporalSpecs(fs,te);
[x,y] = eightshape_variation(t,courtwidth,courtheigth);%ground truth

clean.position.x = x;
clean.position.y = y;

% [dt,t,n] = addJitter(fs,te);
% [dt2,t2,n2] = addJitter(fs2,te);
[dt,t,n] = createTemporalSpecs(fs,te);
[dt2,t2,n2] = createTemporalSpecs(fs2,te);

position.var = 1*ones(size(t));
position.x = generate_signal(x, position.var);
position.y = generate_signal(y, position.var);

R = getRotationMatrixZ(66);
R = R(2:end,2:end);
[x2,y2] = eightshape_variation(t2,courtwidth,courtheigth);
randomOffset = 15;
CDR = ([x2 y2]+randomOffset)*R;

position.rotatedoffset.x = CDR(:,1);
position.rotatedoffset.y = CDR(:,2);
clean.velocity.x = gradient(CDR(:,1),dt2);
clean.velocity.y = gradient(CDR(:,2),dt2);

velocity.var = 0.5 * ones(size(t2));
velocity.x = generate_signal(clean.velocity.x, velocity.var); %rotated
velocity.y = generate_signal(clean.velocity.y, velocity.var); %rotated
velocity.res = sqrt(velocity.x.^2 + velocity.y.^2);

acceleration.var = ones(length(t),1)*2;
acceleration.x = gradient(velocity.x,dt2);
acceleration.y = gradient(velocity.y,dt2);
acceleration.res = gradient(velocity.res,dt2);

temporalspecs.fs = fs;
temporalspecs.fs2 = fs2;
temporalspecs.t = t;
temporalspecs.t2 = t2;
temporalspecs.dt = dt;
temporalspecs.dt2 = dt2;
temporalspecs.n = n;
temporalspecs.n2 = n2;
position.x2 = x2;
position.y2 = y2;
end


function [outsignal, outvar] = generate_signal(signal, var)
[rowSignal,columnsSignal] = size(signal);
[rowVar,columnVar] = size(var);
if rowSignal ~= rowVar || columnsSignal ~= columnVar
    var = var' ;
end
noise = randn(size(signal)).*sqrt(var);
outsignal = signal + noise;
outvar = var;
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
