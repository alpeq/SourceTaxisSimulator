function [normOdorL, normOdorR, incL, decL, incR, decR] = normalize_signals(sumOdorL, sumOdorR, incL, decL, incR, decR, count, sizeW)
   
    normOdorL = sumOdorL/count;
    normOdorR = sumOdorR/count;
    
    incL = incL/(count * sizeW);
    decL = decL/(count * sizeW);
    incR = incR/(count * sizeW);
    decR = decR/(count * sizeW);
    
end