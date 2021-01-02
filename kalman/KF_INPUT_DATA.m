function [dt,t,n,Signals,velocity,clean] = KF_INPUT_DATA()
matfilename = [mfilename '.mat'];
if not(exist(matfilename,'file'))
    dt = 0.1;% time step
    t=(0:dt:1000)';
    n = numel(t);
    clean.position = cos(0.1*t)+10*sin(t)+0.5*t;%ground truth
    clean.velocity = gradient(clean.position,dt);
    
    Signals(1).var = 5*ones(size(t));
    Signals(1).sig = generate_signal(clean.position, Signals(1).var);
    Signals(2).var = 0.1*(cos(8*t)+10*t);
    Signals(2).sig = generate_signal(clean.position, Signals(2).var );
    Signals(3).var = 0.1*(sin(2*t)+10);
    Signals(3).sig  = generate_signal(clean.position, Signals(3).var );
    Signals(4).var = 0.1*ones(size(t));
    Signals(4).sig  = generate_signal(clean.position, Signals(4).var );
    
    % velocity(1).var = zeros(n,1);
    % velocity(1).sig = zeros(n,1);
    velocity(1).var = sin(t*10)+100;
    velocity(1).sig = generate_signal(clean.velocity, velocity(1).var);
    save(matfilename);
else
    load(matfilename);
end
end


function [outsignal, outvar] = generate_signal(signal, var)
noise = randn(size(signal)).*sqrt(var);
outsignal = signal + noise;
outvar = var;
end