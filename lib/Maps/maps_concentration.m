% MAPS_CONCENTRATION Synthetic and experimental arenas of odourant
% dispersion. It converts to .mat files
%

clear all
close all
map = 666 ;
if (map == 1)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Map 1 extracted from real arena in Konstanz  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig=figure;
    load('odor_mapping_ori.mat');  % The original map is not square for representation purposes is modified
    
    % X Redimension map to square for representation purposes Original x(2,-3) y(0,12)
    newZeros= round((size(map_mean,2)/5)*((12-5)/2)); %12->new 5->old length of the y axes each side
    map_mean= [zeros(newZeros,size(map_mean,1))  map_mean  zeros(newZeros,size(map_mean,1))];
    map_std= [zeros(newZeros,size(map_std,1))  map_std  zeros(newZeros,size(map_std,1))];
    
    res = map_mean./max(max(map_mean));
    x=linspace(5.5,-6.5); % Original 2,-3 0,12
    y=linspace(0,12);
    
    imh = imagesc(x,y,(res)); %flip
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Normalize Odorant');
    hold on
    
    save('odor_mapping1.mat','map_mean', 'map_std')
    
    figure()
    imh = imagesc(x,y,(map_std)); %flip
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Standard deviation');
    hold on
    
elseif (map == 2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Map 2 Artificially simulated from paper sug  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Variables of our model
    source = [0 0];
    Cdt = 0.2; % turbulent diffusion m/s^2 0.1 Wideness of the pulse
    l = 1.6;% release rate mol/s            1.6
    v = 1;% wind speed m/s                   1
    theta = -pi/2;% Angle x axis to upwind direction
    
    x=linspace(5.5,-6.5); % Square map for representation purposes
    y=linspace(0,12);
    
    [X,Y] = meshgrid(x,y);
    r = sqrt( (source(1) - X).^2 + ((source(2) - Y).^2) );
    dx = (source(1) - X) .* cos(theta) + (source(2) - Y) .* sin(theta);
    map_mean = (l./(2*pi*Cdt.*(r.^(1/19)))).* exp (-v .* (r-dx) ./(2*Cdt)); % divided by r idea from an infotaxis cuban paper
    % if removed the 100% is in the middle   1/9 good view
    map_std = 0.05 * ones(size(map_mean));            % 1% of std deviation correspond to 1 in std normal value
    fig=figure;
    %res = res./max(max(res)); Normalization in the interpolation is
    %included
    imh = imagesc(x,y,(map_mean)); %flip
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Normalize Odorant');
    hold on
    save('odor_mapping2.mat','map_mean', 'map_std')
    %save('odor_mapping2_long.mat','map_mean', 'map_std')
    figure()
    imh = imagesc(x,y,(map_std)); %flip
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Standard deviation');
    hold on
elseif (map == -2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Map 2 Artificially simulated from paper sug  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Variables of our model
    source = [0 0];
    Cdt = 0.02; % turbulent diffusion m/s^2 0.1 Wideness of the pulse
    l = 1.6;% release rate mol/s            1.6
    v = 1;% wind speed m/s                   1
    theta = -pi/2;% Angle x axis to upwind direction
    
    x=linspace(5.5,-6.5); % Square map for representation purposes
    y=linspace(0,12);
    
    [X,Y] = meshgrid(x,y);
    r = sqrt( (source(1) - X).^2 + ((source(2) - Y).^2) );
    dx = (source(1) - X) .* cos(theta) + (source(2) - Y) .* sin(theta);
    map_mean = (l./(2*pi*Cdt.*(r.^(1/19)))).* exp (-v .* (r-dx) ./(2*Cdt)); % divided by r idea from an infotaxis cuban paper
    % if removed the 100% is in the middle   1/9 good view
    map_std = 0.05 * ones(size(map_mean));            % 1% of std deviation correspond to 1 in std normal value
    fig=figure();
    %res = res./max(max(res)); Normalization in the interpolation is
    %included
    imh = imagesc(x,y,(map_mean)); %flip
    title('Pulse Wideness 0.07 (m/s^2) ')
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Normalized Concentration','FontSize',12, 'FontWeight', 'bold');
    hold on
    save('odor_mapping2_tiny.mat','map_mean', 'map_std')
    figure()
    imh = imagesc(x,y,(map_std)); %flip
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Standard deviation', 'FontSize',12, 'FontWeight', 'bold');
    hold on
    
    %set(gca,'linewidth', 2,'fontsize',12, 'fontWeight', 'bold') % Sets the width of the axis lines, font size, font
    
    
    
elseif (map == 0)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Map 2 Artificially simulated from paper sug  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Variables of our model
    source = [0 0];
    Cdt = 0.07; % turbulent diffusion m/s^2 0.1 Wideness of the pulse
    l = 1.6;% release rate mol/s            1.6
    v = 1;% wind speed m/s                   1
    theta = -pi/2;% Angle x axis to upwind direction
    
    x=linspace(5.5,-6.5); % Square map for representation purposes
    y=linspace(0,12);
    
    [X,Y] = meshgrid(x,y);
    r = sqrt( (source(1) - X).^2 + ((source(2) - Y).^2) );
    dx = (source(1) - X) .* cos(theta) + (source(2) - Y) .* sin(theta);
    map_mean = (l./(2*pi*Cdt.*(r.^(1/19)))).* exp (-v .* (r-dx) ./(2*Cdt)); % divided by r idea from an infotaxis cuban paper
    % if removed the 100% is in the middle   1/9 good view
    map_std = 0.05 * ones(size(map_mean));            % 1% of std deviation correspond to 1 in std normal value
    fig=figure();
    %res = res./max(max(res)); Normalization in the interpolation is
    %included
    imh = imagesc(x,y,(map_mean)); %flip
    title('Pulse Wideness 0.07 (m/s^2) ')
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Normalize Odorant');
    hold on
    save('odor_mapping2_small.mat','map_mean', 'map_std')
    figure()
    imh = imagesc(x,y,(map_std)); %flip
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Standard deviation');
    hold on
    
elseif (map == 4)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Map 2 Artificially simulated from paper sug  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Variables of our model
    source = [0 0];
    Cdt = 0.6; % turbulent diffusion m/s^2 0.1 Wideness of the pulse
    l = 1.6;% release rate mol/s            1.6
    v = 1;% wind speed m/s                   1
    theta = -pi/2;% Angle x axis to upwind direction
    
    x=linspace(5.5,-5.5); % Square map for representation purposes
    y=linspace(0,12);
    %y=linspace(0,24);
    
    [X,Y] = meshgrid(x,y);
    r = sqrt( (source(1) - X).^2 + ((source(2) - Y).^2) );
    dx = (source(1) - X) .* cos(theta) + (source(2) - Y) .* sin(theta);
    map_mean = (l./(2*pi*Cdt.*(r.^(1/19)))).* exp (-v .* (r-dx) ./(2*Cdt)); % divided by r idea from an infotaxis cuban paper
    % if removed the 100% is in the middle   1/9 good view
    map_std = 0.05 * ones(size(map_mean));            % 1% of std deviation correspond to 1 in std normal value
    fig=figure();
    
    imh = imagesc(x,y,(map_mean)); %flip
    
    title('Pulse Wideness 0.6 (m/s^2) ')
    colormap gray;   % set colormap
    tin=colorbar;
    title(tin,'Normalize Odorant');
    hold on
    figure()
    imh = imagesc(x,y,(map_std)); %flip
    colormap gray;   % set colormap
    tin=colorbar;
    title(tin,'Standard deviation');
    hold on
    
elseif (map == 444)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Map 2 Artificially simulated from paper sug  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Variables of our model
    source = [0 0];
    Cdt = 0.6; % turbulent diffusion m/s^2 0.1 Wideness of the pulse
    l = 1.6;% release rate mol/s            1.6
    v = 1;% wind speed m/s                   1
    theta = -pi/2;% Angle x axis to upwind direction
    
    x=linspace(5.5,-6.5); % Square map for representation purposes
    %y=linspace(0,12);
    y=linspace(0,24);
    
    [X,Y] = meshgrid(x,y);
    r = sqrt( (source(1) - X).^2 + ((source(2) - Y).^2) );
    dx = (source(1) - X) .* cos(theta) + (source(2) - Y) .* sin(theta);
    map_mean = (l./(2*pi*Cdt.*(r.^(1/19)))).* exp (-v .* (r-dx) ./(2*Cdt)); % divided by r idea from an infotaxis cuban paper
    % if removed the 100% is in the middle   1/9 good view
    map_std = 0.05 * ones(size(map_mean));            % 1% of std deviation correspond to 1 in std normal value
    fig=figure();
    imh = imagesc(x,y,(map_mean)); %flip
    
    title('Pulse Wideness 0.6 (m/s^2) ')
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Normalize Odorant');
    hold on
    save('odor_mapping2_big_long.mat','map_mean', 'map_std')
    figure()
    imh = imagesc(x,y,(map_std)); %flip
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Standard deviation');
    hold on
    
elseif (map == 44)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Map 2 Artificially simulated from paper sug  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Variables of our model
    source = [0 0];
    Cdt = 0.6; % turbulent diffusion m/s^2 0.1 Wideness of the pulse
    l = 1.6;% release rate mol/s            1.6
    v = 1;% wind speed m/s                   1
    theta = -pi/2;% Angle x axis to upwind direction
    
    x=linspace(5.5,-6.5); % Square map for representation purposes
    y=linspace(0,12);
    
    [X,Y] = meshgrid(x,y);
    r = sqrt( (source(1) - X).^2 + ((source(2) - Y).^2) );
    dx = (source(1) - X) .* cos(theta) + (source(2) - Y) .* sin(theta);
    map_mean = (l./(2*pi*Cdt.*(r.^(1/16)))).* exp (-v .* (r-dx) ./(2*Cdt)); % divided by r idea from an infotaxis cuban paper
    % if removed the 100% is in the middle   1/9 good view
    map_std = 0.05 * ones(size(map_mean));            % 1% of std deviation correspond to 1 in std normal value
    fig=figure();
    %res = res./max(max(res)); Normalization in the interpolation is
    %included
    imh = imagesc(x,y,(map_mean)); %flip
    title('Pulse Wideness 0.6 (m/s^2) ')
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Normalize Odorant');
    hold on
    save('odor_mapping22_big.mat','map_mean', 'map_std')
    figure()
    imh = imagesc(x,y,(map_std)); %flip
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Standard deviation');
    hold on
    
    
    
    
elseif (map == 666)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Map 2 Artificially simulated from paper sug  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Variables of our model
    source = [0 0];
    Cdt = 0.6; % turbulent diffusion m/s^2 0.1 Wideness of the pulse
    l = 1.6;% release rate mol/s            1.6
    v = 1;% wind speed m/s                   1
    theta = -pi/2;% Angle x axis to upwind direction
    
    x=linspace(5.5,-6.5); % Square map for representation purposes
    y=linspace(0,12);
    
    [X,Y] = meshgrid(x,y);
    r = sqrt( (source(1) - X).^2 + ((source(2) - Y).^2) );
    dx = (source(1) - X) .* cos(theta) + (source(2) - Y) .* sin(theta);
    map_mean = (l./(2*pi*Cdt.*(r.^(1/16)))).* exp (-v .* (r-dx) ./(2*Cdt)); % divided by r idea from an infotaxis cuban paper
    % if removed the 100% is in the middle   1/9 good view
    map_std = 0.05 * ones(size(map_mean));            % 1% of std deviation correspond to 1 in std normal value
    map_mean = map_mean./(max(max(map_mean)));
    %Thresholded
    id= (map_mean>0.49) &(map_mean<0.6);
    map_mean(id) = 1;
    map_mean(~id) = 0;
    
    fig=figure();
    %res = res./max(max(res)); Normalization in the interpolation is
    %included
    
    imh = imagesc(x,y,(map_mean)); %flip
    title('Pulse Wideness 0.6 (m/s^2) ')
    colormap gray;   % set colormap
    tin=colorbar;
    title(tin,'Normalize Odorant');
    hold on
    %save('odor_mapping22_big.mat','map_mean', 'map_std')
    figure()
    imh = imagesc(x,y,(map_std)); %flip
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Standard deviation');
    hold on
    
    
elseif (map == 3)
    
    fig=figure;
    load('odor_eq2000.mat');  % The original map is not square for representation purposes is modified
    
    magnifier = 1; % Equation data with big differences between source values and the rest. Try to resize the values
    map_mean= (1+log(Ck'/max(max(Ck)))./20);% .* randi([0 1], size(Ck')); %normalize AND Random dissapearance
    
    map_std = 0.05 * ones(size(map_mean));  %zeros(size(map_mean)); % NO NOISE %          % 1% of std deviation correspond to 1 in std normal value
    
    x=linspace(5.5,-6.5,100); % Original 0-5 and 0-6 with values x,y traspose?
    y=linspace(0,12,120);
    
    imh = imagesc(x,y,map_mean); %(100:end),(map_mean(100:end,:))); %flip
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Normalize Odorant');
    hold on
    
    save('odor_mapping3.mat','map_mean', 'map_std')
    
    figure()
    imh = imagesc(x,y,(map_std)); %flip
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Standard deviation');
    hold on
    
end
