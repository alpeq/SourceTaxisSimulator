function [odorant, sumOdorL, sumOdorR] = addNoiseDB2System(odorant, count, noise, endT)

if noise.bool
    odorant(:,end-count+1:end) = awgn(odorant(:,end-count+1:end),noise.powernoise);
else
    odorant(:,end-count+1:end) = odorant(:,end-count+1:end).*endT ;
end

sumOdorL = sum(odorant(1,end-count+1:end));
sumOdorR = sum(odorant(2,end-count+1:end));

end
