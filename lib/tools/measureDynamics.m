function [incL, decL, incR, decR] = measureDynamics(local_odor, odorant, count, sizeW, sensitivity)
    
    
    
    windowSize= count * sizeW; % Memory of 4 iterations    
    
    mem = ones(1,windowSize);
    odor_global = 1; 
    
    if odor_global == 1
        left_odor = round(odorant(1,:),sensitivity);
        right_odor = round(odorant(2,:),sensitivity);
    else 
        left_odor = round(local_odor(1,:),sensitivity);
        right_odor = round(local_odor(2,:),sensitivity);
    end
    
    left_c = [left_odor(1,1) left_odor(1,1:end-1)];   
    right_c = [right_odor(1,1) right_odor(1,1:end-1)];
    
    if odor_global == 1
        incL = ((left_odor-left_c) > 0);        
        decL = ((left_odor-left_c) < 0);
        incR = ((right_odor-right_c) > 0);
        decR = ((right_odor-right_c) < 0);
        
        incL = sum(incL(1+numel(incL)-min(numel(incL), numel(mem)):end).*mem(1+numel(mem)-min(numel(incL), numel(mem)):end));
        decL = sum(decL(1+numel(decL)-min(numel(decL), numel(mem)):end).*mem(1+numel(mem)-min(numel(decL), numel(mem)):end));
        incR = sum(incR(1+numel(incR)-min(numel(incR), numel(mem)):end).*mem(1+numel(mem)-min(numel(incR), numel(mem)):end));
        decR = sum(decR(1+numel(decR)-min(numel(decR), numel(mem)):end).*mem(1+numel(mem)-min(numel(decR), numel(mem)):end));
    else
        incL = sum((left_odor-left_c) > 0);
        decL = sum((left_odor-left_c) < 0);
        incR = sum((right_odor-right_c) > 0);
        decR = sum((right_odor-right_c) < 0);
    end
end
