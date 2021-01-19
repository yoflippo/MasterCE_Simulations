function makeLatexTableFromSimulationResults(ap_MAT_file)
% MAKETABLELATEX <short description>
%
%
%

% $Revision: 0.0.0 $  $Date: 2020-06-21 $
% Creation of this function.

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
% load('runallComparisonSingle_results.mat')


[numSolvers,~] = size(results);
[~,c] = size(results);
anchors = [3:2+c];
numDataSets = length(results(1,1).locations.clean);
blFirstCaption = true;
for typeOfNoise = {'Gaussian','UWB'}
    if isequal(typeOfNoise{:},'UWB')
        typeOfNoiseLatex = [ '{\color{orange}\textbf{' typeOfNoise{:} '}}'];
    else
        typeOfNoiseLatex = [ '{\color{blue}\textbf{' typeOfNoise{:} '}}'];
    end
    for nAnc = 1:length(anchors)
        %         ap.output = fullfile(this.Path,'output');
        ap.output = fullfile(extractBefore(this.Path,'SIMULATION'),'/THESIS/TUD_ENS_MSc_Thesis/chapters/results');
        resultmatrix = [1:numDataSets 999999]'; % +1 for last row
        anchor = num2str(anchors(nAnc));
        if blFirstCaption
            caption = ['RMS errors for \textbf{' num2str(numDataSets) '} datasets with {\color{red} \textbf{' anchor '}} anchors. ' ...
                'For every solver the performance (duration in seconds) is given in the last row. ' ...
                'The data of each dataset has some ' typeOfNoiseLatex ' noise added. ' ...
                'The best performances are visualised in boldface. ' ...
                'The tables below (up to \cref{table:results_UWB_' num2str(anchors(end)) '}) show the results for different number of anchors and different types of noise. ' ...
                'The total testbench consists of over 30000 measurements.'];
            blFirstCaption = false;
        else
            caption = ['RMS errors for \textbf{' num2str(numDataSets) '} datasets with {\color{red} \textbf{' anchor '}} anchors ' ...
                'and ' typeOfNoiseLatex ' noise added. '];
        end
        resultmatrixColumnNames = {'Dataset'};
        
        for nS = 1:numSolvers
            curr = results(nS,nAnc);
            checkoutCleanData(curr);
            if isequal(typeOfNoise{:},'UWB')
                resultmatrix = [resultmatrix [[curr.error.dist.noise.uwb{:}]'; sum([curr.duration.noise.uwb{:}])] ];
            else
                resultmatrix = [resultmatrix [[curr.error.dist.noise.gaussian{:}]'; sum([curr.duration.noise.gaussian{:}])] ];
            end
            resultmatrixColumnNames(nS+1) = {curr.name};
        end
        resultmatrix = round(resultmatrix,2);
        nm.output = ['results_' typeOfNoise{:} '_' anchor ];
        ap.output = fullfile(ap.output,    [nm.output '.tex']);
        writeTexFile(resultmatrix,'columnlabels',resultmatrixColumnNames,'title',caption,'filename',ap.output,'label', nm.output);
    end
end
end %function


%% Check if clean works out
function checkoutCleanData(curr)
if mean([curr.error.dist.clean{:}]) > 1e-12
    keyboard
    error([mfilename ' Can not happen: solver with clean data should work perfectly']);
end
end

function writeTexFile(varargin)
%% Parse varargin
% Test for right input
minargin = 1;
maxargin = (minargin+5)*2;
if nargin < minargin
    error([ mfilename ':Needs at minimum' num2str(minargin) ' argument(s) ']);
end
if nargin > maxargin
    error([ mfilename ':Needs max ' num2str(minargin) ' arguments ']);
end

filename = [mfilename '_tex.tex'];
if nargin > 1
    input.data = varargin{1};
    
    % parse the others
    for narg = 2:nargin
        try
            sc = lower(varargin{narg});
            switch sc
                case {'columnlabels'}
                    input.tableColLabels = varargin{narg+1};
                case {'title'}
                    input.tableCaption = varargin{narg+1};
                case {'label'}
                    input.tableLabel = varargin{narg+1};
                case {'filename'}
                    filename = varargin{narg+1};
                case {'rowlabels'}
                    input.tableRowLabels = varargin{narg+1};
                otherwise
                    % Do nothing in the case of varargin{narg+1};
            end
        catch
        end
    end
end

input.tablePlacement = 'tph';
input.ms.boldRowLowest = true;
input.ms.firstColumnWholeNumber = true;
input.dataFormat = {'%.0f',1,'%.2f',length(input.tableColLabels)-1};
% input.makeCompleteLatexDocument = 1;
latex = latexTableUWB(input);
%% Restore last row first column, add midrule
idx = find(contains(latex,'999999'));
idxmidrule = find(contains(latex,'\midrule'));
latex2 = [latex(1:idx-1); latex(idxmidrule); latex(idx:end)]
latex = replace(latex2,[num2str(999999)],'Duration');

%% Write to file
fid=fopen(filename,'w');
[nrows,~] = size(latex);
for row = 1:nrows
    fprintf(fid,'%s\n',latex{row,:});
end
fclose(fid);
fclose('all');

end