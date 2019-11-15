%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Antennae Oscillator                                                  %
%                                                                       %
%  alz@mmmi.sdu.dk                                                      %
%  simulation_croach_PARAM:                                             %
%   test in predefine positions heading towards the target a subset of  %
%   parameters V defined from the ADAM algorithm                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function simulation_croach(name, map, decision_model, iterations, steps, antennae, noise_sig, var2mod, vectorTest, closeAll)
function [plotHandles] = simulation_GUI(xname, handles)

% Variables for oscillator
global odorant
global odor_raw
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
conf_GUI;

% Simulation parameters
N = steps;       % Number of steps or end condition 30
endT = 0.2;   % Time for each step
sizeWindow = 3;  % Number of windows considered for increments and decrements of dynamics model
sensitivity = count_decimals(0.01); % Sensitivity measuring the dynamics of the plume how big in concentration is the difference to count as a increment/decrement
% Simulation parameters
t = 0.01:0.001:endT ;      % Time simulation declaration

load('InterpolationFunctions')

rng('shuffle')  % Seed Randomize function for the standard deviation

%---> Random initial positions between a range of distance to the target
% and angle
%radious = 10;           % Equidistant to target
%yP = sqrt(radious^2 - xP^2);
%degP = 90 + (20-(-20)).*rand(1,1) + (-20);   % 90 is the direction of the source
%croachInitPos = [xP yP deg2rad(degP)]; % Initial positioning simulation
xP = handles.position.xpos;%vPos; anotehr param
yP = handles.position.ypos;
degP = atan2(yP - handles.map.source(2), xP - handles.map.source(1))+ deg2rad(handles.position.devpos) ;% -20 to 20 deg from the source
croachInitPos = [xP yP degP]; % Initial positioning simulation
dist0 = norm(croachInitPos(1:2) - handles.map.source(1:2));

%%%INIT%%%
tIN = [];
odor_raw = [];
odorant= []; % Track States of oscillators
% Initial Conditions
Ginistep = antennae.init; % short 0.7;0;-0.7;0;1;0;1;0  wide -0.7;0;0.7;0;1;0;1;0
croachPos = croachInitPos; %Source(1) 60 Theta_enc(2) x, y, 0 6 as initial point Keep Theta_enc for basic decission making
Path = zeros(N,size(croachPos,2));
Path(1,1:3) = croachPos;
AntennaePathP = zeros(N,2*2); % (x,y) per antenna


Rp = 0;     % Return reward signals

% Gui Parameters
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Positive perturbation
%%%%%% Loop of movement + antennae %%%%%%
model.theta3l = linspace(handles.antennae.mp - abs(handles.antennae.ampLeft)/2, handles.antennae.mp + abs(handles.antennae.ampLeft)/2 ,40);
model.theta3r = linspace(-handles.antennae.mp - abs(handles.antennae.ampRight)/2 , -handles.antennae.mp + abs(handles.antennae.ampRight)/2, 40);

drawHandles = struct;

for ip= 0:N-2
    % Initial conditions of integration 2 antennae 4 equations for each
    count = 0;
    local_odor = [];
    iniParam = Ginistep;  % GiniStep(1) -> motor-neuron antenna left Value is changed inside of integration function each iteration
    % Initial Croach position in the map
    [posAntL, posAntR, tipL, tipR] = forwardKinematics(croachPos, iniParam(1), iniParam(3), model, handles.antennae);
    
    [drawHandles, FMean] = drawCroach_GUI(croachPos,tipL,tipR,handles, drawHandles, handles.map.dynamic, (ip*endT), FMean); % Update map figure
    plotHandles = [drawHandles.lantennae drawHandles.rantennae drawHandles.croach];
    pause(0.01)
    
    %[fl,fr] = getOdorant(posAntL, posAntR);
    fl = FMean(posAntL);
    fr = FMean(posAntR);
    
    
    %Integration function
    [ts,ys] = ode45(@(t,y) hopf_oscillator(t,y,fl,fr,handles.antennae),t,iniParam);
    
    [odorant, sumOdorL, sumOdorR] = addNoiseDB2System(odorant, count, handles.noise, endT);
    [incL, decL, incR, decR] = measureDynamics(local_odor, odorant, count, sizeWindow, sensitivity);
    [normOdorL, normOdorR, incL, decL, incR, decR] = normalize_signals(sumOdorL, sumOdorR, incL, decL, incR, decR, count, sizeWindow);
    
    
    % Update position -> CHECK THE position update according to differential drive!!!!
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
    %%%%%%%%%%%%%%%%%
    %Stop Conditions     ---> We need to manage going backwards
    if ((newCroachPos(2) >= 0) && (abs(newCroachPos(1)) <= 6))
        croachPos = newCroachPos;
    else
        Path(ip+2,:) = croachPos ;
        break;
    end
    Path(ip+2,:) = croachPos ;
    AntennaePathP(ip+1,:) = [tipL tipR];
    
    if CONFIG.stop
        break
    elseif CONFIG.pause
        mydlg = warndlg('Press OK to continue', 'Pause dialog');
        waitfor(mydlg);
        CONFIG.pause = 0;
    end
    
end   % End for

% Save trayectory for plotting
fileName = fullfile(dirMat,strcat(xname,datestr(now,'yyyymmddTHHMMss')));
save(fileName)

%%%%%
%__> Draw path of the croach
%cleanPlot_GUI(handles.axesHandle);

[phand] = drawPaths_GUI(Path,handles.axesHandle, handles.map.source);
plotHandles = [plotHandles phand];


