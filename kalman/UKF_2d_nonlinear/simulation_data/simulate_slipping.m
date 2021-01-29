function slipmoments = simulate_slipping(timevector)
dt = mean(diff(timevector));
durationSlip = 0.2;
t = 0:dt:durationSlip;
y = -200*(t.^2) + (100.*t);
slipmoments = zeros(size(timevector));

slipTimeBegin = round(length(timevector)/2);
slipTimeEnd = slipTimeBegin + length(y)-1;

slipmoments(slipTimeBegin:slipTimeEnd) = slipmoments(slipTimeBegin:slipTimeEnd) + 100*y';
% plot(slipmoments);
end

