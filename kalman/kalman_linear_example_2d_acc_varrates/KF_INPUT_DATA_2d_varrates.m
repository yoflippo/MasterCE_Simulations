function [dt,t,n,Signals,velocity,clean,acceleration,dt2,t2,n2] = KF_INPUT_DATA_2d_varrates()
matfilename = [mfilename '.mat'];
cd(fileparts(mfilename('fullpath')));
if not(exist(matfilename,'file'))
    [dt,t,n,Signals,velocity,clean,acceleration,dt2,t2,n2] = generateAll();
    save(matfilename);
else
    load(matfilename);
    [~,t2,n2,Signals2,velocity2,clean2,acceleration2,dt2a,t2a,n2a] = generateAll();
    if (not(isequal(t2,t)) || ...
            not(isequal(n2,n)) || ...
            not(isequal(clean.position.x,clean2.position.x)) || ...
            not(isequal(Signals(1).var,Signals2(1).var)) || ...
            not(isequal(velocity(1).var,velocity2(1).var)))
        [dt,t,n,Signals,velocity,clean,acceleration,dt2,t2,n2] = generateAll();
        clear t2 n2 Signals2 clean2 velocity2 acceleration2 dt2a t2a n2a
        save(matfilename);
    end
    clear t2 n2 Signals2 clean2 velocity2 acceleration2 dt2a t2a n2a
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

function [dt,t,n,Signals,velocity,clean,acceleration,dt2,t2,n2] = generateAll()
te = 15; %sec
dt = 1/100;% time step
t=(0:dt:te)';
n = numel(t);
dt2 = 1/10;
t2=(0:dt2:te)';
n2 = numel(t);
courtwidth = 10;
courtheigth = 10;
[x,y] = eightshape_with_variation(t,courtwidth,courtheigth);%ground truth
[x2,y2] = eightshape_with_variation(t2,courtwidth,courtheigth);
clean.position.x = x;
clean.position.y = y;
clean.velocity.x = gradient(clean.position.x,dt);
clean.velocity.y = gradient(clean.position.y,dt);

Signals(1).var = 1*ones(size(t2));
Signals(1).sig.x = generate_signal(x2, Signals(1).var);
Signals(1).sig.y = generate_signal(y2, Signals(1).var);

velocity(1).var = ones(length(t),1)*0.05;
velocity(1).sig.x = generate_signal(clean.velocity.x, velocity(1).var);
velocity(1).sig.y = generate_signal(clean.velocity.y, velocity(1).var);

acceleration.sig.x = gradient(velocity.sig.x,dt);
acceleration.sig.y = gradient(velocity.sig.y,dt);
acceleration.var = var([acceleration.sig.x; acceleration.sig.y]);
end

function [outsignal, outvar] = generate_signal(signal, var)
noise = randn(size(signal)).*sqrt(var);
outsignal = signal + noise;
outvar = var;
end