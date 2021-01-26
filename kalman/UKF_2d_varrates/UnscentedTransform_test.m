function UnscentedTransform_test()
clc;
n = 2;
alpha = 0.3;
beta = 2;
kappa = 0.1;
x = [0 0];
P = [32 15; 15 40];

weights = UKF_lin_weights(n,alpha,beta,kappa);
mssp = MerweScaledSigmaPoints(x,P,weights);

testSigmas = [0 0;
  3.612  1.934;
  2.496  6.231;
 -3.612  1.934;
 -2.496  6.231];

[x,P] = UnscentedTransform(testSigmas,weights);

Ptest = [101.992380952381,2.84217094304040e-14;
    2.84217094304040e-14,3789.90846457266];
xtest = round([0,43.2010582010582],5);

if all(round(Ptest,5)==round(P,5),'all') || ...
        all(round(xtest,5)==round(x,5),'all')
    disp([mfilename ' WORKING'])
else
    error([mfilename ' NOT WORKING']);
end

end

