function [dt,t,n,Signals,velocity,clean] = KF_INPUT_DATA_2d()
matfilename = [mfilename '.mat'];
if not(exist(matfilename,'file'))
    [dt,t,n,Signals,velocity,clean] = generateAll();
    save(matfilename);
else
    load(matfilename);
    [~,t2,n2,Signals2,velocity2,clean2] = generateAll();
    if (not(isequal(t2,t)) || ...
            not(isequal(n2,n)) || ...
            not(isequal(Signals(1).var,Signals2(1).var)) || ...
            not(isequal(Signals(2).var,Signals2(2).var)) || ...
            not(isequal(Signals(3).var,Signals2(3).var)) || ...  
            not(isequal(velocity(1).var,velocity2(1).var)) || ...
            not(isequal(Signals(4).var,Signals2(4).var)))
        [dt,t,n,Signals,velocity,clean] = generateAll();
        clear t2 n2 Signals2 clean2 velocity2
        save(matfilename);
    end
end
end

function [dt,t,n,Signals,velocity,clean] = generateAll()
dt = 0.1;% time step
t=(0:dt:20)';
n = numel(t);
[x,y] = eightshape_with_variation(t,10,10);%ground truth
% x = t; %cos(0.1*t)+2*sin(t)+t;%ground truth
% y = 0.1*cos(0.2*t)+t; %0.1*cos(0.2*t)+0.1*sin(t)+t;%ground truth
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
end

function [outsignal, outvar] = generate_signal(signal, var)
noise = randn(size(signal)).*sqrt(var);
outsignal = signal + noise;
outvar = var;
end