close all; clearvars; clc;

anchors = [ -981.1193  800.0000
  900.0000  805.5893
  200.2697 -600.0000];
measuredDistances = 1.0e+03 *[1.2454    1.1984    0.6569];
calculatedPositionTag = [-7.7389   23.1065];

error = getErrorDistancesPosition(anchors,measuredDistances,calculatedPositionTag);