clearvars; clc; close all;

 figfiles = dir(['*.fig']);
 
 for i = 1:length(figfiles)
    currfile = figfiles(i);
    currfile.fullpath = fullfile(currfile.folder,currfile.name);
    open(currfile.fullpath);
    set(gcf,'Visible','off');
    savefig(gcf,currfile.fullpath);
 end