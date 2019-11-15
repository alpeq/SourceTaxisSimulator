function [drawHandles, FFMean] = drawCroach_GUI(posCroach, tipR, tipL, handles, drawHandles, dynamic, time_simulation, FMean)
% Due to representation with the images the input parameter is tipL and
% tipR which will be processed like the other way around

global model

orientation = posCroach(3); 
lenCr = -6; % Be carefull with this factor
var = who;

% Map creation with concentration 
if (isempty(fieldnames(drawHandles)) == 1 )
    
    % Initial values    
    %tipL = [posCroach(1)+lenCr*cos(orientation) posCroach(2)+lenCr*sin(orientation)+0.25*sin(orientation)];
    %tipR = [posCroach(1)+lenCr*cos(orientation) posCroach(2)+lenCr*sin(orientation)-0.25*sin(orientation)];    

    drawHandles.lantennae = line; 
    drawHandles.rantennae = line; 
    drawHandles.croach = line;
end


% Due to representation perspective left is right and other way around
iniR = [posCroach(1) + model.l1 * cos(model.theta0 + orientation) + model.l2 * cos(model.theta0 + orientation + model.theta12l) 
    posCroach(2) + model.l1 * sin(model.theta0 + orientation) + model.l2 * sin(model.theta0 + orientation + model.theta12l)]; % 
iniL = [posCroach(1)+ model.l1 * cos(model.theta0 + orientation) + model.l2 * cos(model.theta0 + orientation + model.theta12r)  
    posCroach(2) + model.l1 * sin(model.theta0 + orientation) + model.l2 * sin(model.theta0 + orientation + model.theta12r)];
endL = [tipL(1) tipL(2)];
endR = [tipR(1) tipR(2)];

delete(drawHandles.lantennae);
delete(drawHandles.rantennae);
delete(drawHandles.croach);

% Plot concentration
if dynamic && mod(time_simulation,1)==0
    
%   Dont generate from the source since each file are 10MB
%   [FFMean, FFStd] = Fgaden2map(handles.map.string, int2str(floor(time_simulation)), handles.axesHandle);
    try
    %    % GAden generates each second
        fname = strcat(handles.map.string,'_iteration_',int2str(floor(time_simulation) + handles.map.offset));
        str_map = load(fname);
        handles.map.map_mean = str_map.map_mean;
        handles.map.map_std = zeros(size(str_map.map_mean));%str_map.map_std;


        res = handles.map.map_mean./max(max(handles.map.map_mean));
        x=linspace(6,-6); % Original 2,-3 0,12
        y=linspace(0,24,200);
        cla(handles.axesHandle);
        imagesc(handles.axesHandle, linspace(6.5,-6.5),y,zeros(100,100)); %flip 
        imh = imagesc(handles.axesHandle, x,y,(res)); %flip 
        colormap default;   % set colormap
    %    tin=colorbar;
    %    title(tin,'Normalize Odorant');
    %    hold on

       % Interpolation functions
        FFMean = str_map.FMean;   
    catch
        FFMean = FMean;   
    end    
    
else
    FFMean = FMean;   
end
drawHandles.lantennae = plot(handles.axesHandle, [iniL(1) endL(1)],[iniL(2) endL(2)], 'Color',[1 0 0],'LineWidth',3); 
drawHandles.rantennae = plot(handles.axesHandle, [iniR(1) endR(1)],[iniR(2) endR(2)], 'Color',[1 0 0],'LineWidth',3); 

drawHandles.croach = plot(handles.axesHandle, posCroach(1),posCroach(2),'or',...
                     'MarkerFaceColor',[1 1 1],...
                     'MarkerEdgeColor',[1 1 1],...
                     'MarkerSize',model.sizeCircle);   
                 
end