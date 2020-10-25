function FromSimulationResultsMakeErrorAndDurationGraph(ap_MAT_file)
% $Revision: 0.0.0 $  $Date: 2020-06-21 $
% Creation of this function.

%% Administration
close all; clc;
this.Path = fileparts(mfilename('fullpath'));
cd(this.Path);
rmpath(genpath(this.Path));
addpath(genpath(this.Path));

if ~exist('ap_MAT_file','var')
    [nm.file, ap.file] = uigetfile('*.mat');
    ap.filefull = fullfile(ap.file,nm.file);
else
    ap.filefull = ap_MAT_file;
end
load(ap.filefull);
ap.output = fullfile(extractBefore(this.Path,'SIMULATION'),'/THESIS/TUD_ENS_MSc_Thesis/Figures');

[numSolvers,~] = size(results);
[~,c] = size(results);
anchors = [3:2+c];
numDataSets = length(results(1,1).locations.clean);


%% Go over types of noises implemented
for typeOfNoise = {'Gaussian','UWB'}
    if isequal(typeOfNoise{:},'UWB')
        typeOfNoiseLatex = [ '{\color{orange}\textbf{' typeOfNoise{:} '}}'];
    else
        typeOfNoiseLatex = [ '{\color{blue}\textbf{' typeOfNoise{:} '}}'];
    end
    
    [matrixRMS_error,matrixDuration,resultmatrixColumnNames]= extractDataInFormatForPlotting(results,anchors,this,numSolvers,typeOfNoise);
    
    makeAndSaveBarPlot(typeOfNoise,matrixRMS_error,resultmatrixColumnNames,anchors,ap, ...
        'simulation','RMS error [.]',['RMS error i.r.t. number of anchors, ' typeOfNoise{:}])
    makeAndSaveBarPlotDuration(typeOfNoise,matrixDuration,resultmatrixColumnNames,anchors,ap, ...
        'duration','Average duration [s]',['Duration i.r.t. number of anchors, ' typeOfNoise{:}])
end
end %function




function [matrixRMS_error,matrixDuration,resultmatrixColumnNames]= extractDataInFormatForPlotting(results,anchors,this,numSolvers,typeOfNoise)
for nAnc = 1:length(anchors)
    for nS = 1:numSolvers
        curr = results(nS,nAnc);
        checkoutCleanData(curr);
        if isequal(typeOfNoise{:},'UWB')
            matrixRMS_error(nAnc,nS) = mean([curr.error.dist.noise.uwb{:}]');
            matrixDuration(nAnc,nS) = sum([curr.duration.noise.uwb{:}]);
        else
            matrixRMS_error(nAnc,nS) = mean([curr.error.dist.noise.gaussian{:}]');
            matrixDuration(nAnc,nS) = sum([curr.duration.noise.gaussian{:}]);
        end
        resultmatrixColumnNames(nS+1) = {curr.name};
    end
    matrixRMS_error = round(matrixRMS_error,2);
end
end

function makeAndSaveBarPlotDuration(typeOfNoise,data,names,anchors,ap,strbartype,ylab,tit)
figure('Position',  [200 200 800 800])
barh(data);
setAxisAndBarplotAndSaveDuration(typeOfNoise,data,names,anchors,ap,strbartype,ylab,tit)
end

function makeAndSaveBarPlot(typeOfNoise,data,names,anchors,ap,strbartype,ylab,tit)
figure('Position',  [200 200 800 800])
bar(data);
setAxisAndBarplotAndSave(typeOfNoise,data,names,anchors,ap,strbartype,ylab,tit)
end

function setAxisAndBarplotAndSaveDuration(typeOfNoise,data,names,anchors,ap,strbartype,ylab,tit)
grid on; grid minor; xlabel('Number of Anchors'); xlabel(ylab); title(tit);
legend(names(2:end),'Location','best');
xlim([floor(min(min(data))) ceil(max(max(data)))])
set(gca,'YTickLabel',anchors);
ylabel('Anchors');
%% Make first yticklabel bold to remind the reader
%     ylbl=yticklabels;
%     ix=[1];                        % define those to change
%     for i=1:length(ix)                 % make up the new ones for those locations...
%         ylbl(ix(i))= {['\bf' ylbl{ix(i)}]};
%     end
%     yticklabels(ylbl)
set(gca,'XScale','log')
tightAxis()

nmoutput = ['results_' strbartype '_' typeOfNoise{:} '.png' ];
saveas(gcf,fullfile(ap.output,nmoutput));
end

function setAxisAndBarplotAndSave(typeOfNoise,data,names,anchors,ap,strbartype,ylab,tit)
grid on; grid minor; xlabel('Number of Anchors'); ylabel(ylab); title(tit);
xlabel('Anchors');
legend(names(2:end),'Location','best');
ylim([floor(min(min(data))) ceil(max(max(data)))])
set(gca,'XTickLabel',anchors);

%% Make first yticklabel bold to remind the reader
%     ylbl=yticklabels;
%     ix=[1];                        % define those to change
%     for i=1:length(ix)                 % make up the new ones for those locations...
%         ylbl(ix(i))= {['\bf' ylbl{ix(i)}]};
%     end
%     yticklabels(ylbl)
set(gca,'YScale','log')
tightAxis()

nmoutput = ['results_' strbartype '_' typeOfNoise{:} '.png' ];
saveas(gcf,fullfile(ap.output,nmoutput));
end

%% Check if clean works out
function checkoutCleanData(curr)
if mean([curr.error.dist.clean{:}]) > 1e-12
    keyboard
    error([mfilename ' Can not happen: solver with clean data should work perfectly']);
end
end


