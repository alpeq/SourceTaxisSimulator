function [odorant, sumOdorL, sumOdorR] = addNoiseDB2System(odorant, count, noise, endT)
% ADDNOISEDB2SYSTEM  Add noise to the normalize odourant signal
%   adding white noise to the signal at specific SNR with awgn()
%
%   addNoiseDB2System(odorant, count, noise, endT)
%   ->  odourant: full path concentration signal 
%   ->  count: number of steps to apply noise (only last iteration)
%   ->  noise: DB value of noise
%   <-  endT: normalization timestep 
%

odorant(:,end-count+1:end) = odorant(:,end-count+1:end).*endT ;
if noise.bool
    odorant(:,end-count+1:end) = awgn(odorant(:,end-count+1:end),noise.powernoise);
end
sumOdorL = sum(odorant(1,end-count+1:end));
sumOdorR = sum(odorant(2,end-count+1:end));

end
