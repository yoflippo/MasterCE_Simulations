function MerweScaledSigmaPoints_test()
clc;
x = [0 0];
P = [1 0.1;
    0.1 1];
sigmaPoints = MerweScaledSigmaPoints(x,P);

testMatrix = [0         0;
    0.1732    0.0173;
    0    0.1723;
    -0.1732   -0.0173;
    0   -0.1723];

if all(testMatrix==round(sigmaPoints.sigmaPoints,4),'all')
    disp([mfilename ' WORKING'])
else
    error([mfilename ' NOT WORKING']);
end
