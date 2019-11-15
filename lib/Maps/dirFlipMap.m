% It takes one directory where there is a series of 
% odourant simulations. All files with the format *_iteration_%d where %d 
% is a number starting with 0 are flip upside down and save in the same
% file.


clc
clear all
close all

myDir = uigetdir; %gets directory
prestr = strsplit(myDir,'/');
prefix = prestr(end);
%myFiles = dir(fullfile(myDir,'DynamicMap','Test','out*')); %gets all txt files in struct
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

    % Check results
    %imagesc(xv,yv,map_mean)
    %pause(0.1)
    %title('Gaden data')
    %colormap default;   % set colormap
    %tin=colorbar;
    %title(tin,'Normalize Odorant');


        %Interpolation
       [FMean, FStd] = create_interpFunc_out(map_mean, map_std, xm, xM, ym, yM);

        %Save
        baseNtokn = strsplit(baseFileName,'_');
        posfix = baseNtokn(end);
        fNMat = fullfile(myDir, strcat(prefix,'_iteration_',posfix,'.mat'));
        save(string(fullFileName),'map_mean','map_std','FMean','FStd');


end


