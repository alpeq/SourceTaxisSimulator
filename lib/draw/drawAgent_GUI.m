function [drawHandlers, FFMean] = drawAgent_GUI(posCroach, tipR, tipL, handlers, drawHandlers, dynamic, time_simulation, FMean)
% DRAWAGENT_GUI Draws the agent position
%
%   This function draw the agent and the environment, dynamic environments 
%   needs timestamp to load the new environment sensory functions
%
%   drawAgent_GUI(posCroach, tipR, tipL, handlers, drawHandlers, dynamic, time_simulation, FMean)
%   -> posCroach: position of the agent in the environments
%   -> tipR: position of the Right appendage in the environment frame
%   -> tipL: position of the Left appendage in the environment frame
%   -> handlers: GUI handlers
%   -> drawHandlers: drawing handlers 
%   -> dynamic: 
%   -> time_simulation: 
%   -> FMean: list of handlers to delete
%   <- drawHandles: handles of the axis
%   <- FFMean: update environment sensory function
%

% Due to representation convection with the background images
% the input parameter is tipL and tipR which will be processed like the other way around

global model

orientation = posCroach(3);

% Map creation with concentration
if (isempty(fieldnames(drawHandlers)) == 1 )
    
    drawHandlers.lantennae = line;
    drawHandlers.rantennae = line;
    drawHandlers.croach = line;
end


% Due to representation perspective left is right and other way around
iniR = [posCroach(1) + model.l1 * cos(model.theta0 + orientation) + model.l2 * cos(model.theta0 + orientation + model.theta12l)
    posCroach(2) + model.l1 * sin(model.theta0 + orientation) + model.l2 * sin(model.theta0 + orientation + model.theta12l)]; %
iniL = [posCroach(1)+ model.l1 * cos(model.theta0 + orientation) + model.l2 * cos(model.theta0 + orientation + model.theta12r)
    posCroach(2) + model.l1 * sin(model.theta0 + orientation) + model.l2 * sin(model.theta0 + orientation + model.theta12r)];
endL = [tipL(1) tipL(2)];
endR = [tipR(1) tipR(2)];

delete(drawHandlers.lantennae);
delete(drawHandlers.rantennae);
delete(drawHandlers.croach);

% Plot concentration
if dynamic && mod(time_simulation,1)==0
    
    %   Dont generate from the source since each file are 10MB
    try
        %    % GAden generates each second
        fname = strcat(handlers.map.string,'_iteration_',int2str(floor(time_simulation) + handlers.map.offset));
        str_map = load(fname);
        handlers.map.map_mean = str_map.map_mean;
        handlers.map.map_std = zeros(size(str_map.map_mean));%str_map.map_std;
        
        
        res = handlers.map.map_mean./max(max(handlers.map.map_mean));
        x=linspace(6,-6); % Original 2,-3 0,12
        y=linspace(0,24,200);
        cla(handlers.axesHandle);
        imagesc(handlers.axesHandle, linspace(6.5,-6.5),y,zeros(100,100)); %flip
        imh = imagesc(handlers.axesHandle, x,y,(res)); %flip
        colormap default;   % set colormap
        
        % Interpolation functions
        FFMean = str_map.FMean;
    catch
        FFMean = FMean;
    end
    
else
    FFMean = FMean;
end
drawHandlers.lantennae = plot(handlers.axesHandle, [iniL(1) endL(1)],[iniL(2) endL(2)], 'Color',[1 0 0],'LineWidth',3);
drawHandlers.rantennae = plot(handlers.axesHandle, [iniR(1) endR(1)],[iniR(2) endR(2)], 'Color',[1 0 0],'LineWidth',3);

drawHandlers.croach = plot(handlers.axesHandle, posCroach(1),posCroach(2),'or',...
    'MarkerFaceColor',[1 1 1],...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerSize',model.sizeCircle);

end