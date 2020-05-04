close all;
clearvars;
% % % % % % % % % % % % % % Mu = 0;
% % % % % % % % % % % % % % Sig = 1;
% % % % % % % % % % % % % % X = Mu-10*Sig:0.01:Mu+10*Sig; 
% % % % % % % % % % % % % % Y = normpdf(X, Mu, Sig);
% % % % % % % % % % % % % % sum(Y)
% % % % % % % % % % % % % % plot(X,Y)

rng(0,'twister');
a = 1;
b = 0;
y = a.*randn(1000,1) + b;
stats = [mean(y) std(y) var(y)]