close all; clearvars; clc;

if ~isequal(PercentageChange([40]',[50]'),[25]')
    error([mfilename ': check it']);
end

if ~isequal(PercentageChange([40 40]',[50 60]'),[25 50]')
    error([mfilename ': check it']);
end

if ~isequal(PercentageChange([40 40],[50 60]),[25 50])
    error([mfilename ': check it']);
end

if ~isequal(PercentageChange([40 30],[50 60]),[25 100])
    error([mfilename ': check it']);
end

disp([mfilename ' works fine']);