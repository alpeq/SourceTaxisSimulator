function drawLastFile_GUI(nameExp)
% Retrieve the last file with the name of the Experiment and print the
% trajectory and the directness plot in a file in Figures/
global Source
global map_mean

% Save Figures Fig
dirFig = 'Figures/';
dirMat = 'MatrixD/';

filesDir = dir(fullfile(dirMat,strcat('*',nameExp,'*')));
lastName = filesDir(end).name;
inFile= fullfile(dirMat, lastName);
load(inFile);
close(handles.figure1);
FPath = figure('Renderer', 'painters', 'Position', [10 10 600 1000]);

subplot(2,1,1)
set(gcf,'Visible', 'off');
res = handles.map.map_mean./max(max(handles.map.map_mean));
x=linspace(6,-6); % Original 2,-3 0,12
y=linspace(0,24,200);

imh = imagesc(x,y,(res)); %flip
colormap default;   % set colormap
tin=colorbar;
title(tin,'Normalized Concentration', 'FontSize',12);
hold on
axis off

for i=0:(size(Path,2)/3)-1
    p1 = plot( Path(:,1+3*i), Path(:,2+3*i),'wo','MarkerSize',1);
    h1 = plot(Path(1,1+3*i), Path(1,2+3*i),'rs','MarkerSize',20);
    %% Directness plot points
    p1 = [Path(1:end-1,1+3*i) Path(1:end-1,2+3*i)];
    p2 = [Path(2:end,1+3*i) Path(2:end,2+3*i)];
    theta2point = atan2(p2(:,2)-p1(:,2),p2(:,1)-p1(:,1));
    theta2source = atan2(handles.map.source(2)-p1(:,2), handles.map.source(1)-p1(:,1));
    radi = theta2point - theta2source;
    li = sqrt((p2(:,1) - p1(:,1)).^2 + (p2(:,2) - p1(:,2)).^2);
    v_avg = complex(sum(li.*cos(radi))./sum(li),  -1*sum(li.*sin(radi))./sum(li));
end
%camroll(-90);
%%%%%%%%%%%%%%%

subplot(2,1,2)
set(gcf,'Visible', 'off');

polarplot(v_avg, 'Color', [0 0 0], 'Marker','x', 'MarkerSize', 10, 'LineWidth', 2,'LineStyle', 'none' ); % 'MarkerSize', 5, 'LineWidth', 1

rlim([0.5 1])
set(gca, 'linewidth', 2,'fontsize',16, 'fontWeight', 'bold') % Sets the width of set(gca,'linewidth', 2,'fontsize',12, 'fontWeight', 'bold')

fullFileNameEpsc = fullfile(dirFig, strcat(lastName,'_path.eps'));
saveas(FPath, fullFileNameEpsc,'epsc');
close(FPath);



end

