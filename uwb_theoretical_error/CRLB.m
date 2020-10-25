close all; clc; clearvars;

SNRdb = 1;
A = 2;
SNR = A^(SNRdb/20)


c = physconst('LightSpeed');
beta = 1.5e9;

sqrtvar = c/(2*sqrt(2)*pi*sqrt(SNR)*beta)