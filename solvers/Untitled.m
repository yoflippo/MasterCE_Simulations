close all;
clearvars;
clc

% % % % % % % % % % % % % % A = [3 3; -1 -1]';
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % Create rotation matrix
% % % % % % % % % % % % % % theta = 350; 
% % % % % % % % % % % % % % R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
% % % % % % % % % % % % % % % Rotate your point(s)
% % % % % % % % % % % % % % point = A; % arbitrarily selected
% % % % % % % % % % % % % % rotpoint = R*point;
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % plot(A(1,:),A(2,:),'go');
% % % % % % % % % % % % % % hold on; 
% % % % % % % % % % % % % % plot(rotpoint(1,:),rotpoint(2,:),'rx')


% % % % data1=randn(10000,1);
% % % % data2=(data1.^2-3*data1+5)+0.01*randn(size(data1)); 
% % % % %data2 is a function of data1 + noise
% % % % ref=randn(size(data1));
% % % % subplot(1,2,1);scatter(data1(:),ref(:));
% % % % subplot(1,2,2);scatter(data1(:),data2(:));

load('create_uwb_dummy_data_combine_path_17_200420211845.mat')
[r,c] = size(data.Distances);
data2=createUWBNoise(data.Distances,5); 
ref=randn(r,c);
subplot(1,2,1);normplot(ref(:));
subplot(1,2,2);normplot(data2(:));

h = adtest(data2(:)-mean(data2(:)),'Distribution','norm')

