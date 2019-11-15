% It takes one directory and all files from a gaden simulation that starts
% with out* are load, a cut in z for a 2D is done and save along with the
% interpolation function in a .mat file.

clc
clear all
close all

cutNumber = 14;
myDir = uigetdir; %gets directory
prestr = strsplit(myDir,'/');
prefix = prestr(end);
%myFiles = dir(fullfile(myDir,'DynamicMap','Test','out*')); %gets all txt files in struct
myFiles = dir(fullfile(myDir,'out*')); %gets all txt files in struct
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  a = load(fullFileName);

    zcut = a(a(:,3) == cutNumber, :);      % The cut in volume
    x = zcut(:,1);
    y = zcut(:,2);
    c = zcut(:,4); % concentration

    xv = linspace(min(x), max(x));
    yv = linspace(min(y), max(y));

    [X,Y] = meshgrid(xv, yv);
    Z = griddata(x,y,c,X,Y);


    % Resize
    nx=[-6 6];
    ny=[0 24];
    xv=linspace(nx(1),nx(2));
    yv=linspace(ny(2),ny(1));

    %%%%%%%%%%%%%%%%%%%%%%%%%FILTERING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Z(1:10,:) = 0;                      % Do we need to filter??                YES
    %Z(40:60,40:60) = Z(40:60,40:60)/1000;                      % Do we need to filter??


    %%%%%%%%%%%%%%%%%%%%%%%%%FLIP IT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    map_mean = Z./max(max(Z));
    %map_mean = flipud(Z./max(max(Z)));

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
       [FMean, FStd] = create_interpFunc_out(map_mean, map_std, -6,6,0,24);

        %Save
        baseNtokn = strsplit(baseFileName,'_');
        posfix = baseNtokn(end);
        fNMat = fullfile(myDir, strcat(prefix,'_iteration_',posfix,'.mat'));
        save(string(fNMat),'map_mean','map_std','FMean','FStd');


end


