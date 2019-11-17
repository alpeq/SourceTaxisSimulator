function [meanL, meanR] = getOdorant(PosL, PosR)
% GETODORANT get odorant value given a position in space of the sensor
% based on the interpolation functions previously built
%
load('InterpolationFunctions')

meanL = FMean(PosL);
meanR = FMean(PosR);


end