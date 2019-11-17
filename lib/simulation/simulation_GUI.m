function [plotHandles] = simulation_GUI(xname, handles)
% SIMULATION_GUI main loop of the agent simulation for GUI parameterisation
%
%   simulation_GUI(xname, handles)
%   -> xname: name of simulation
%   -> handles: struct with parameters from GUI
%

% Variables for oscillator
global odorant
global tIN
global Ginistep
global N
global endT
global count
global local_odor
global model
global CONFIG
global antennae;
global steps

dirMat = 'MatrixD/';
conf_GUI;                   % Agent basic config --> model

% Simulation parameters
N = steps;                  % Timeout, number of steps
endT = 0.2;                 % Time for integration of each step
t = 0.01:0.001:endT ;       % Time simulation declaration
sizeWindow = 3;  % BDynamic model needs the number of samples to consider
sensitivity = count_decimals(0.01); % Sensitivity measuring the dynamics of the plume how big in concentration is the difference to count as a increment/decrement
load('InterpolationFunctions')
rng('shuffle')  % Seed Randomize function for noise addition

% Map placement
xP = handles.position.xpos;%vPos; anotehr param
yP = handles.position.ypos;
degP = atan2(yP - handles.map.source(2), xP - handles.map.source(1))+ deg2rad(handles.position.devpos) ;
croachInitPos = [xP yP degP];

% Initialisation
tIN = [];
odorant= [];
Ginistep = antennae.init; % short 0.7;0;-0.7;0;1;0;1;0  wide -0.7;0;0.7;0;1;0;1;0
croachPos = croachInitPos; %Source(1) 60 Theta_enc(2) x, y, 0 6 as initial point Keep Theta_enc for basic decission making
Path = zeros(N,size(croachPos,2));
Path(1,1:3) = croachPos;
AntennaePathP = zeros(N,2*2); % Antennae path

% Gui Parameters of the simulation
handles.antennae.static;
handles.antennae.freqLeft;
handles.antennae.freqRight;
handles.antennae.mp;
handles.antennae.ampLeft;
handles.antennae.ampRight;

handles.antennae.kon ;
handles.antennae.koff ;
handles.antennae.ks ;

handles.controller.alpha;
handles.controller.g0;

% Update antennae range parameter based on GUI
model.theta3l = linspace(handles.antennae.mp - abs(handles.antennae.ampLeft)/2, handles.antennae.mp + abs(handles.antennae.ampLeft)/2 ,40);
model.theta3r = linspace(-handles.antennae.mp - abs(handles.antennae.ampRight)/2 , -handles.antennae.mp + abs(handles.antennae.ampRight)/2, 40);
drawHandles = struct;

for i= 0:N-2
    count = 0;
    local_odor = [];
    % FK From antennae state to the position in the environment
    iniParam = Ginistep;  % motor state of the antenna changes inside of integration function
    [posAntL, posAntR, tipL, tipR] = forwardKinematics(croachPos, iniParam(1), iniParam(3), model, handles.antennae);
    [drawHandles, FMean] = drawAgent_GUI(croachPos,tipL,tipR,handles, drawHandles, handles.map.dynamic, (i*endT), FMean);
    plotHandles = [drawHandles.lantennae drawHandles.rantennae drawHandles.croach];
    pause(0.01)
    
    % Get new concentration vector in the antennae range
    fl = FMean(posAntL);
    fr = FMean(posAntR);
    
    % Integration function outputs concentration and new antennae state
    %  in global odourant local_odour Ginistep
    [ts,ys] = ode45(@(t,y) hopf_oscillator(t,y,fl,fr,handles.antennae),t,iniParam);
    
    % Concentration signal processing: Noise + integrate ON/OFF + normalization
    [odorant, sumOdorL, sumOdorR] = addNoiseDB2System(odorant, count, handles.noise, endT);
    [incL, decL, incR, decR] = measureDynamics(odorant, count, sizeWindow, sensitivity);
    [normOdorL, normOdorR, incL, decL, incR, decR] = normalize_signals(sumOdorL, sumOdorR, incL, decL, incR, decR, count, sizeWindow);
    
    % Update position based on sensorimotor model
    switch(handles.controller.model)
        case {'3braitenberg','3Braitenberg'}
            newCroachPos = braitenbergLoveDecisionUpdate(croachPos, normOdorL, normOdorR, handles.controller.alpha, handles.controller.g0, handles.antennae.ks);
        case {'3dynamics','3Dynamics'}
            newCroachPos = dynamicsLoveDecisionUpdate(croachPos, incL, decL, incR, decR, normOdorL, normOdorR, handles.controller.alpha, handles.controller.g0, handles.antennae.kon, handles.antennae.koff, handles.antennae.ks);
        case {'3CRdynamics','3CRDynamics'}
            newCroachPos = dynamicsLoveCrossedDecisionUpdate(croachPos, incL, decL, incR, decR, normOdorL, normOdorR, handles.controller.alpha,handles.controller.g0, handles.antennae.kon, handles.antennae.koff, handles.antennae.ks);
        otherwise
            warning('Unexpected decission model type. No position updated.')
    end
    %   Only possible inside of the environment limits
    if ((newCroachPos(2) >= 0) && (abs(newCroachPos(1)) <= 6))
        croachPos = newCroachPos;
    else
        Path(i+2,:) = croachPos;
        break;
    end
    Path(i+2,:) = croachPos;
    AntennaePathP(i+1,:) = [tipL tipR];
    % Check for Pause or Stop
    if CONFIG.stop
        break
    elseif CONFIG.pause
        mydlg = warndlg('Press OK to continue', 'Pause dialog');
        waitfor(mydlg);
        CONFIG.pause = 0;
    end
    
end

% Save trayectory mat for plotting
fileName = fullfile(dirMat,strcat(xname,datestr(now,'yyyymmddTHHMMss')));
save(fileName)

% Draw full trajectory
[phand] = drawPaths_GUI(Path,handles.axesHandle, handles.map.source);
plotHandles = [plotHandles phand];

end
