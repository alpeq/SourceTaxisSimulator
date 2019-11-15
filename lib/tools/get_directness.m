function [ direct_v ] = get_directness( Path, Source )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

direct_v = [];
for i=0:(size(Path,2)/3)-1
        %% directness plot points
        p1 = [Path(1:end-1,1+3*i) Path(1:end-1,2+3*i)];
        p2 = [Path(2:end,1+3*i) Path(2:end,2+3*i)];
        theta2point = atan2(p2(:,2)-p1(:,2),p2(:,1)-p1(:,1));
        theta2source = atan2(Source(2)-p1(:,2),Source(1)-p1(:,1));        
        radi = theta2point - theta2source;
        li = sqrt((p2(:,1) - p1(:,1)).^2 + (p2(:,2) - p1(:,2)).^2);
        v_avg = complex(sum(li.*cos(radi))./sum(li),  -1*sum(li.*sin(radi))./sum(li));
        direct_v = [direct_v v_avg];       
end
    
end

