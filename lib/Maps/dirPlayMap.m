% It takes all .mat files with the format _iteration_ and show them in order
% from 0 - 1000

clc
clear all
close all

myDir = uigetdir; %gets directory
prestr = strsplit(myDir,'/');
prefix = prestr(end);


nx=[-6 6];
    ny=[0 24];
    xv = linspace(min(nx), max(nx));
    yv = linspace(min(ny), max(ny));
    
for loop = 0:1000
    fNMat = fullfile(myDir, strcat(prefix,'_iteration_',int2str(loop),'.mat'));    
    a = load(string(fNMat));
    imagesc(xv,yv,a.map_mean)
    pause(0.5);
end

