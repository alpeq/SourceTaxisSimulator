function [FMean, FStd] = create_interpFunc_out(map_mean, map_std, xmin, xmax, ymin, ymax)
% CREATE_INTERPFUNC_OUT Creates the interpolation function of the given map
% (mean, standard_deviation)

res = map_mean./max(max(map_mean));
std = map_std;

x=linspace(xmin,xmax,size(res,2)); % Original 2,-3
y=linspace(ymin,ymax,size(res,1));
[X, Y] = meshgrid(x,y);

vX = reshape(X.', [], 1);
vY = reshape(Y.', [], 1);
vMean = reshape(res.', [], 1);
vStd = reshape(std.', [], 1);

% First Interpolation square distance neighbours 100x100 'natural'
FMean = scatteredInterpolant(vX,vY,vMean);
FStd = scatteredInterpolant(vX,vY,vStd);

end