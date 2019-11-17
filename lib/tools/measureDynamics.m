function [incL, decL, incR, decR] = measureDynamics(odorant, count, sizeW, sensitivity)
% MEASUREDYNAMICS Measure the effect of the ON/OFF neuron in cockroaches
% integrating the thresholded differences
%
%   measureDynamics(local_odor, odorant, count, sizeW, sensitivity)
%   ->  odourant: full path concentration signal
%   ->  count: number of steps to apply noise (only last iteration)
%   ->  sizeW: size of window
%   ->  sensitivity: sensitivity for the increment / decrement
%   <-  incL : increments left antenna
%   <-  decL : decrements left antennae
%   <-  incR : increments right antenna
%   <-  decR : decrements right antenna
%

windowSize= count * sizeW;  % Memory size
mem = ones(1,windowSize);


left_odor = round(odorant(1,:),sensitivity);
right_odor = round(odorant(2,:),sensitivity);

left_c = [left_odor(1,1) left_odor(1,1:end-1)];
right_c = [right_odor(1,1) right_odor(1,1:end-1)];


incL = ((left_odor-left_c) > 0);
decL = ((left_odor-left_c) < 0);
incR = ((right_odor-right_c) > 0);
decR = ((right_odor-right_c) < 0);

incL = sum(incL(1+numel(incL)-min(numel(incL), numel(mem)):end).*mem(1+numel(mem)-min(numel(incL), numel(mem)):end));
decL = sum(decL(1+numel(decL)-min(numel(decL), numel(mem)):end).*mem(1+numel(mem)-min(numel(decL), numel(mem)):end));
incR = sum(incR(1+numel(incR)-min(numel(incR), numel(mem)):end).*mem(1+numel(mem)-min(numel(incR), numel(mem)):end));
decR = sum(decR(1+numel(decR)-min(numel(decR), numel(mem)):end).*mem(1+numel(mem)-min(numel(decR), numel(mem)):end));

end
