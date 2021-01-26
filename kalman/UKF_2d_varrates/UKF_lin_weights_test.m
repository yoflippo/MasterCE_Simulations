function UKF_lin_weights_test()
n = 4;
alpha = 0.1;
beta = 2;
kappa = 1;

weights = UKF_lin_weights(n,alpha,beta,kappa);

Wc_test = [-76.0100   10.0000   10.0000   10.0000   10.0000   10.0000   10.0000   10.0000   10.0000];
Wm_test = [-79.0000   10.0000   10.0000   10.0000   10.0000   10.0000   10.0000   10.0000   10.0000];


if all(Wc_test==round(weights.covariance,4),'all') || ...
    all(Wm_test==round(weights.mean,4),'all')
    disp([mfilename ' WORKING'])
else
    error([mfilename ' NOT WORKING']);
end

end