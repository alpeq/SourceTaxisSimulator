% GADEN2MAP Convert gaden format to matrix
%
clc
clear all
close all
matfile = 'odor_gaden_croach_center_85.mat'
sf = fullfile('mapsFromGaden','croach_center_iteration_85');
a = load(sf);

zcut = a(a(:,3) == 14, :);
x = zcut(:,1);
y = zcut(:,2);
c = zcut(:,4); % concentration

xv = linspace(min(x), max(x));
yv = linspace(min(y), max(y));

[X,Y] = meshgrid(xv, yv);
Z = griddata(x,y,c,X,Y);

figure()
surf(X, Y, Z);
grid on
%set(gca, 'ZLim',[0 100])
shading interp


% Resize
nx=[-6 6];
ny=[0 24];
xv=linspace(nx(1),nx(2));
yv=linspace(ny(2),ny(1));

[X,Y] = meshgrid(xv, yv);
figure()
surf(X, Y, Z);
grid on
shading interp

%
figure()

map_mean = flipud(Z./max(max(Z)));
map_mean(isnan(map_mean)) = 0;      % Remove nans
map_std = 0.05 * ones(size(map_mean));
save(matfile,'map_mean','map_std')

imagesc(xv,yv,map_mean)
title('Gaden data')
colormap default;   % set colormap
tin=colorbar;
title(tin,'Normalize Odorant');


