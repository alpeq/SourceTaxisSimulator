%******************************************%
% Configuration Parameters                 %
% * Simulation parameters                  %
% * Cockroach Forward Kinematic values     %
% * Source in (0.33 , 1)                   %
%******************************************%

global model
global antennae
global iterations 

global steps 

global noise_sig


global sizeWindow 


 % PARAMS FOR THE GUI


noise_sig = 0;%0.1; 

sizeWindow = 2;     % Not sure

iterations = 20;
steps = 1500; %500


% Antennae
antennae = struct;
antennae.init = [-0.7;0;0.7;0;1;0;1;0]; % short 0.7;0;-0.7;0;1;0;1;0  wide -0.7;0;0.7;0;1;0;1;0
%antennae.init = [0;0;0;0;1;0;1;0]; % short 0.7;0;-0.7;0;1;0;1;0  wide -0.7;0;0.7;0;1;0;1;0

% % PARAMS
% MP = pi/4;
% aa = 2;
% aG = (1*(0.33*4))*1.7;
% aI= 0.33;
% aD= aI * 2;
% aN= 0.33;

    





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Agent Model                %               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%        Forward Kinematic            %
% Coordinates system Traslation
% Lengths of the cockroach    REAL Values: l1 = 1.7;  l2 = 0.25;  l3 = 4;
%                             Experiment2: l1 = 0.85;  l2 = 0.25;  l3 = 2;
l1 = 0.42;    % length from mid-point of the body to antennae
l2 = 0.12;    % perpendicular line mid-head to antenna distance 6.5:1 proportion l1:l2
l3 = 1;       % 1 length of the antennae                          1:2 proportion l1:l3

% Coordinates system Rotation
theta0 = pi;%pi; 3pi4             % Axis rotation reference between coordinate systems Kinematics-Concentration map
theta12l = deg2rad(90);  %radians constant for rotation between coordinate systems from 1st axis to 2nd axis left antennae
theta12r = deg2rad(-90); %radians constant for rotation between coordinate systems from 1st axis to 2nd axis right antennae
theta23l = deg2rad(-90); %radians constant for rotation between coordinate systems from 2nd axis to 3nd axis left antennae
theta23r = deg2rad(90);  %radians constant for rotation between coordinate systems from 2nd axis to 3nd axis right antennae

% model and range of antennae
osciamp=0.71;
% theta3l = 0:0.1:1*pi/2;   % all possible theta2 values
% theta3r = -1*pi/2:0.1:0;  %0:-0.1:-pi/2; % all possible theta2 values
sizeCircle = 19;

model.l1 = l1 ;
model.l2 = l2 ;
model.l3 = l3 ;
model.theta0 = theta0 ;
model.theta12l = theta12l ;
model.theta12r = theta12r ;
model.theta23l = theta23l ;
model.theta23r = theta23r ;
%model.theta3l = theta3l ; Fullfilled in the antennae params
%model.theta3r = theta3r ;
model.sizeCircle = sizeCircle  ;
%model.osciamp=osciamp;

