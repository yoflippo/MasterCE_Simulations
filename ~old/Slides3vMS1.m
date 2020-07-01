close all; clear variables
% system parameters
k1 = 1.3e5;
k2 = 4.2e5;
k3 = 1.4e8;
m1 = 0.038; %kg
m2 = 0.555; %kg;
m3 = 0.620; %kg;

% mass and stiffness matrix
M = [m1	0	0
     0  m2	0
     0  0	m3];
K = [k2+k1	-k2     0
     -k2     k2+k3   -k3
     0      -k3      k3];

%Eigenmatrix
[phi, T] = eig(M^-1*K);
s=tf('s');

[l,w] = size(phi);
for n=1:w
    d(n).phi = phi(:,n);
    d(n).MM  = d(n).phi' * M * d(n).phi;
    d(n).MK  = d(n).phi' * K * d(n).phi;
    d(n).f0  = sqrt(d(n).MM \ d(n).MK) / (2*pi);
    denum(n) = d(n).MM*s^2 + d(n).MK;
end

%% The transfer functions and plot them together
opts = bodeoptions('cstprefs');
opts.FreqUnits = 'Hz';
opts.XLabel
% opts.MagScale = 'log';

ww=logspace(-1,3,1001)*2*pi*10;
cnt = 1;
figure('WindowState','maximized');
for k = 1:w
    for l = 1:w
        xF(k,l) = tf(0);
        for e = 1:w
            xF(k,l) =  xF(k,l) + d(e).phi(k) * d(e).phi(l)/ denum(e);
        end
        subplot(w,w,cnt),bode(xF(k,l),ww,opts); grid on, hold on; title(['d_' num2str(l) '/ F_' num2str(k)]); 
        cnt = cnt + 1;
    end
end

%% Calculate effective modal mass and stiffnes (what the actuator feels)
for nI = 1:length([d.MM])
    for nA = 1:length(d(1).phi)
        Meff(nI,nA) = d(nI).MM / (d(nI).phi(nA)^2);
        MeffLabRow{nI} = ['$M_' num2str(nI) '$'];
        MeffLabCol{nA} = ['$\phi_{' num2str(nI) ',' num2str(nA) '}$'];
        Keff(nI,nA) = d(nI).MK / (d(nI).phi(nA)^2);
        KeffLabRow{nI} = ['$K_' num2str(nI) '$'];
        KeffLabCol{nA} = ['$\phi_{' num2str(nI) ',' num2str(nA) '}$'];
    end
end

% Effective modal mass table
clear input
input.data = Meff; 
input.tablePlacement = 'H';
input.tableColLabels = MeffLabCol;
input.tableRowLabels = MeffLabRow;
input.tableCaption = 'The effective modal mass $ \frac{M_i}{\phi_{i,a}^2} $';
input.tableLabel = 'tab:modalmass:effective';
latex = latexTable(input);

fid=fopen(['ModalMassEffective.tex'],'w');
[nrows,ncols] = size(latex);
for row = 1:nrows
    fprintf(fid,'%s\n',latex{row,:});
end
fclose(fid);

% Effective modal stifness table
clear input
input.data = Keff; 
input.tablePlacement = 'H';
input.tableColLabels = KeffLabCol;
input.tableRowLabels = KeffLabRow;
input.tableCaption = 'The effective modal stiffnes $ \frac{K_i}{\phi_{i,a}^2} $';
input.tableLabel = 'tab:modalmass:effective';
latex = latexTable(input);

fid=fopen(['ModalStiffnesEffective.tex'],'w');
[nrows,ncols] = size(latex);
for row = 1:nrows
    fprintf(fid,'%s\n',latex{row,:});
end
fclose(fid);

% Make modal mass en modal stiffness plot
clear input
input.data = [[d.MM]' [d.MK]']; 
input.tablePlacement = 'H';
input.tableColLabels = {'$M_i$', '$K_i$'};
% input.tableRowLabels = MeffLabRow;
input.tableCaption = 'The modal mass $M_i$ and modal stiffnes $K_i$';
input.tableLabel = 'tab:modalmassstiffness';
latex = latexTable(input);

fid=fopen(['ModalMassStifness.tex'],'w');
[nrows,ncols] = size(latex);
for row = 1:nrows
    fprintf(fid,'%s\n',latex{row,:});
end
fclose(fid);


save(['Workspace_' mfilename char(datetime)]);
disp([mfilename ': FINISHED!!']);