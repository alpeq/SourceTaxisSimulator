% DIRFLIPMAP Opens a directory and reads all the matlab sorted matrixes in order
% to flip them
%

clc
clear all
close all

myDir = uigetdir; %gets directory
prestr = strsplit(myDir,'/');
prefix = prestr(end);
myFiles = dir(fullfile(myDir,'*_iteration_*')); %gets all txt files in struct
for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    a = load(fullFileName);
    
    xm = -6; xM = 6;
    ym = 0;  yM = 24;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%FLIP IT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    map_mean = a.map_mean;
    map_mean = flipud(map_mean);
    
    
    map_mean(isnan(map_mean)) = 0;      % Remove nans
    map_std = 0.05 * ones(size(map_mean));
    
    %Interpolation
    [FMean, FStd] = create_interpFunc_out(map_mean, map_std, xm, xM, ym, yM);
    
    %Save
    baseNtokn = strsplit(baseFileName,'_');
    posfix = baseNtokn(end);
    fNMat = fullfile(myDir, strcat(prefix,'_iteration_',posfix,'.mat'));
    save(string(fullFileName),'map_mean','map_std','FMean','FStd');
    
    
end


