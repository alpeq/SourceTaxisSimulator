function [normOdorL, normOdorR, incL, decL, incR, decR] = normalize_signals(sumOdorL, sumOdorR, incL, decL, incR, decR, count, sizeW)
% NORMALIZE_SIGNALS Normalize the signals of the antennae based on the 
% number of samples
%
%   measureDynamics(local_odor, odorant, count, sizeW, sensitivity)
%   <-  normL : odour normalize left antennae
%   <-  normR : odour normalize right antenna
%   <-  incL : increments left antenna
%   <-  decL : decrements left antennae
%   <-  incR : increments right antenna
%   <-  decR : decrements right antenna
%
normOdorL = sumOdorL/count;
normOdorR = sumOdorR/count;

incL = incL/(count * sizeW);
decL = decL/(count * sizeW);
incR = incR/(count * sizeW);
decR = decR/(count * sizeW);

end