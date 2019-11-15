% Source in (0.33 , 1)
function [meanL, meanR] = getOdorant(PosL, PosR)

load('InterpolationFunctions')

meanL = FMean(PosL);
meanR = FMean(PosR);

%stdL = noiseL*FStd(PosL).*(rand(size(PosL,1),1)*2-1);
%stdR = noiseR*FStd(PosR).*(rand(size(PosR,1),1)*2-1);

end