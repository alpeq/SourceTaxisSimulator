function [pHandles] =  drawPaths_GUI(Path, drawHandle, source)

pHandles = [];
for i=0:(size(Path,2)/3)-1
    p1 = plot(drawHandle, Path(:,1+3*i), Path(:,2+3*i),'wo','MarkerSize',1);
   % p2 = plot(drawHandle, Path(:,1+3*i), Path(:,2+3*i),'w','LineWidth',0.1);
    h1 = plot(drawHandle, Path(1,1+3*i), Path(1,2+3*i),'rs','MarkerSize',20);
    %h2 = plot(drawHandle, Path(end,1+3*i), Path(end,2+3*i),'yo','MarkerSize',10);
    %h3 = plot(drawHandle, source(1), source(2),'b*','MarkerSize',20);
    pHandles = [pHandles p1 h1];% p2 h2 ];%h3];
    %% directness plot points
    p1 = [Path(1:end-1,1+3*i) Path(1:end-1,2+3*i)];
    p2 = [Path(2:end,1+3*i) Path(2:end,2+3*i)];
    theta2point = atan2(p2(:,2)-p1(:,2),p2(:,1)-p1(:,1));
    theta2source = atan2(source(2)-p1(:,2), source(1)-p1(:,1));
    radi = theta2point - theta2source;
    li = sqrt((p2(:,1) - p1(:,1)).^2 + (p2(:,2) - p1(:,2)).^2);
    v_avg = complex(sum(li.*cos(radi))./sum(li),  -1*sum(li.*sin(radi))./sum(li));
end
