function MerweScaledSigmaPoints_test()
clc;
x = [0 0];
P = [1 0.1;
    0.1 1];

weights = UKF_weights(2);
sigmaPoints = MerweScaledSigmaPoints(x,P,weights);

testMatrix = [0         0;
    0.1732    0.0173;
    0    0.1723;
    -0.1732   -0.0173;
    0   -0.1723];

if all(testMatrix==round(sigmaPoints,4),'all')
    disp([mfilename ' WORKING'])
else
    error([mfilename ' NOT WORKING']);
end
