function [dis] = UWB_dis_tof(tt1,tt2,ta1,ta2)
%UWB_TOF Summary of this function goes here
c = physconst('LightSpeed');
tau = [];

if nargin==1 % tt1 = tof
    tau = tt1;
elseif nargin ==4
    tau = ((tt2-tt1)-(ta2-ta1)) / 2;
else
    error([newline mfilename ': ' newline ['nargin should be 2 or 4 not:' num2str(nargin)]   newline]);
end
dis = tau * c;
end

