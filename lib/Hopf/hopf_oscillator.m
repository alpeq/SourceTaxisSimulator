%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Antennae Oscillator
%
%  alpeq16@student.sdu.dk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dy=hopf_oscillator(t,y,F1,F2,antennae) % static_antL, static_antR

global count
global odorant
global local_odor
global tIN
global i
global endT
global Ginistep

%%%%%%%%%%%%%%%%%%%%%%%%%% Model Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Amplitude from reference signal oscillator bigger than output oscillator
mu_s_1 = antennae.ampLeft; %51 71
mu_s_2 = antennae.ampRight; %91
mu_s_3 = 0.91; %91
mu_s_4 = 0.91; %91
% Frequency of oscillator
%f= antennae.freq;% 1;    % 0.5 original
w1 = 2*pi*antennae.freqLeft;
w2 = 2*pi*antennae.freqRight;
% Integration Parameter
%   Radius x,y from the previous step 
r1 = y(1)^2 + y(2)^2;
r2 = y(3)^2 + y(4)^2;
r3 = y(5)^2 + y(6)^2;
r4 = y(7)^2 + y(8)^2;%  %%antennae.freq
%  %% model.amp Amplitude (redefine theta3 according to this because A*cos(wt))
%  %% midPoint of the oscillation
%  weight Inc
%  weigth Dec
%  weight Norm
%  alpha from v=alpha(g-s)
%  maximun value of source
%  Example Optimiza_config;simulation_croach_PARAM([1.6459; 1.8074; 0.24755; 1.8118; 1.2603])



%%%%%%%%%%%%%%% Sensory information and processing %%%%%%%%%%%%%%%%%%%%%%%%
% Amplitud parameters
amp_p_Left=-antennae.ampLeft;       % Peak value in negative cycle
amp_P_Left=antennae.ampLeft;        % Peak Value in positive cycle
amp_p_Right=-antennae.ampRight;       % Peak value in negative cycle
amp_P_Right=antennae.ampRight;        % Peak Value in positive cycle


% From raw values from the diagonal to the position values
% Interpolation points
%
posL = y(1); % Position of the antenna in previous step
posR = y(3);

% Values calculated for the interpolation of Concentration function
stepl=2*antennae.ampLeft/(numel(F1)-1);
if antennae.ampLeft == 0
    tl=antennae.mp* ones(size(F1));    % THE CHANGE before both were the same and I think it was calculating one up and the other one down RECHECK
    odor_l = F1(1);%  You cannnot interpolate the noise in space SERIOUSLY + interp1(tl,F1_dev,max(min(posL,amp_P-stepl),amp_p));%,'nearest');%*(rand*2-1);

else
    tl=[amp_p_Left:stepl:amp_P_Left];    % THE CHANGE before both were the same and I think it was calculating one up and the other one down RECHECK
    odor_l = interp1(tl,F1,max(min(posL,tl(end)),tl(1)),'linear');%  You cannnot interpolate the noise in space SERIOUSLY + interp1(tl,F1_dev,max(min(posL,amp_P-stepl),amp_p));%,'nearest');%*(rand*2-1);
end

stepr=2*antennae.ampRight/(numel(F2)-1);
if antennae.ampRight == 0
    tr=antennae.mp* ones(size(F2));    % THE CHANGE before both were the same and I think it was calculating one up and the other one down RECHECK
    odor_r = F2(1);
else
    tr=[amp_p_Right:stepr:amp_P_Right];
    odor_r = interp1(tr,F2,max(min(posR,tr(end)),tr(1)),'linear');%  + interp1(tr,F2_dev,max(min(posR,amp_P-stepl),amp_p));%,'nearest');%*(rand*2-1);
end


% No random variables in ode functions due to matlab constraints -> we
% suppose the time is gonna be small enough the antennae moves a distance
% equal to one stroke so the value is randomize in getOdorant and constant
% per distance.

statel = odor_l; % TEMPORARY LETS CHECK THE DIFFERENCES
stater = odor_r;

odorant = [odorant [statel ; stater]];
local_odor = [local_odor [statel ; stater]];
tIN= [tIN t+i*endT];


count = count +1;


% Static antennaes
if antennae.static == 1  
    dy = [0; 0;       
          0; 0;
          0; 0;       
          0; 0];
else 
    dy = [((mu_s_1^2 - r1)*y(1) + w1*y(2)); (mu_s_1^2 - r1)*y(2)-w1*y(1); %+1.5*y(6); (mu_s_1^2 - r1)*y(2)-w1*y(1);  
      ((mu_s_2^2 - r2)*y(3) + w2*y(4)); (mu_s_2^2 - r2)*y(4)-w2*y(3); %+1.5*y(8); (mu_s_2^2 - r2)*y(4)-w2*y(3);
      ((mu_s_3^2 - r3)*y(5) + w1*y(6)) + 4*(1-statel)*((mu_s_3^2 - r3)*y(5) + w1*y(6));  (mu_s_3^2 - r3)*y(6)-w1*y(5);     %1 is the expected forecast input of the system
      ((mu_s_4^2 - r4)*y(7) + w1*y(8)) + 4*(1-stater)*((mu_s_4^2 - r4)*y(7) + w1*y(8));  (mu_s_4^2 - r4)*y(8)-w1*y(7); ];

end



Ginistep = [y(1); y(2); y(3); y(4); y(5); y(6); y(7); y(8)];
end
