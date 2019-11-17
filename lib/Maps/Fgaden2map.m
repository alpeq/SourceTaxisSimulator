function [FFMean, FFStd] = Fgaden2map(name, iteration, axesHandle)
% FGADEN2MAP Converts the map to funcion for interpolation

sf = strcat(name,'_iteration_',iteration);
a = load(sf);
zcut = a(a(:,3) == 14, :);      % The cut in volume
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

%map_mean = flipud(Z./max(max(Z)));
map_mean = Z./max(max(Z));
map_mean(isnan(map_mean)) = 0;      % Remove nans
map_std = 0.05 * ones(size(map_mean));

imagesc(axesHandle, xv,yv,map_mean)

%Interpolation already in the .mat
[FFMean, FFStd] = create_interpFunc_out(map_mean, map_std, -6,6,0,24);

end