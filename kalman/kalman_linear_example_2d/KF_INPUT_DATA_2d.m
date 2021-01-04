function [dt,t,n,Signals,velocity,clean,acceleration] = KF_INPUT_DATA_2d()
matfilename = [mfilename '.mat'];
cd(fileparts(mfilename('fullpath')));
if not(exist(matfilename,'file'))
    [dt,t,n,Signals,velocity,clean,acceleration] = generateAll();
    save(matfilename);
else
    load(matfilename);
    [~,t2,n2,Signals2,velocity2,clean2,acceleration2] = generateAll();
    if (not(isequal(t2,t)) || ...
            not(isequal(n2,n)) || ...
            not(isequal(clean.position.x,clean2.position.x)) || ...
            not(isequal(Signals(1).var,Signals2(1).var)) || ...
            not(isequal(Signals(2).var,Signals2(2).var)) || ...
            not(isequal(Signals(3).var,Signals2(3).var)) || ...
            not(isequal(velocity(1).var,velocity2(1).var)) || ...
            not(isequal(Signals(4).var,Signals2(4).var)))
        [dt,t,n,Signals,velocity,clean,acceleration] = generateAll();
        clear t2 n2 Signals2 clean2 velocity2 acceleration2
        save(matfilename);
    end
    clear t2 n2 Signals2 clean2 velocity2 acceleration2
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

function [dt,t,n,Signals,velocity,clean,acceleration] = generateAll()
dt = 1/100;% time step
t=(0:dt:15)';
n = numel(t);
[x,y] = eightshape_with_variation(t,10,10);%ground truth
clean.position.x = x;
clean.position.y = y;
clean.velocity.x = gradient(clean.position.x,dt);
clean.velocity.y = gradient(clean.position.y,dt);

Signals(1).var = 1*ones(size(t));
Signals(1).sig.x = generate_signal(clean.position.x, Signals(1).var);
Signals(1).sig.y = generate_signal(clean.position.y, Signals(1).var);
Signals(2).var = 0.1*(cos(8*t)+10*t);
Signals(2).sig.x = generate_signal(clean.position.x, Signals(2).var);
Signals(2).sig.y = generate_signal(clean.position.y, Signals(2).var);
Signals(3).var = 0.1*(sin(2*t)+10);
Signals(3).sig.x = generate_signal(clean.position.x, Signals(3).var);
Signals(3).sig.y = generate_signal(clean.position.y, Signals(3).var);
Signals(4).var = 0.1*ones(size(t));
Signals(4).sig.x = generate_signal(clean.position.x, Signals(4).var);
Signals(4).sig.y = generate_signal(clean.position.y, Signals(4).var);

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