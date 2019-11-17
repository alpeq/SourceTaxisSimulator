function [croachPos] = braitenbergLoveDecisionUpdate(croachPos, odourL, odourR, alpha, sM, kN)
% BRAITENBERGLOVEDECISIONUPDATE stimulus sensory-motor connection and agent
% update based on differential drive model.
%
%   Sensory-motor connection Braitenberg type 3 Love 
%   v = alpha*( SM - kN*odour) 
%   braitenbergLoveDecisionUpdate(croachPos, odorL, odorR, alpha, sM, kN)
%   -> croachPos: inital position
%   -> odourL: odour concentration from left sensory appendage
%   -> odourR: odour concentration from right sensory appendage
%   -> alpha: velocity scaling factor
%   -> sM: maximun sensory value of the value
%   -> kN: stimulus scaling factor
%   <- croachPos: new position in time
%
% See also: braitenbergDecisionUpdate, dynamicsDecsionUpdate,
% dynamicsLoveDecisionUpdate, dynamicsLoveCrossedDecsionUpdate
%
global model
global endT

g = sM * endT;


contributionL = kN*odourL;
contributionR = kN*odourR;


% Braitenberg model 3: Love
v_l = alpha*( g - contributionL);
v_r = alpha*( g - contributionR);


%Update Position
if (v_l ~= v_r)
    R = (model.l1)*(v_r + v_l)/(v_r - v_l);
    robot_omega = (v_r - v_l)/(model.l1*2) ;
    icc = [croachPos(1) - (R*sin(croachPos(3)+model.theta0)), ...
        croachPos(2) + (R*cos(croachPos(3)+model.theta0))];
    
    croachPos = [cos(robot_omega*endT) -sin(robot_omega*endT) 0;...
        sin(robot_omega*endT)  cos(robot_omega*endT) 0;...
        0                 0                1]...
        *...
        [R*sin(croachPos(3)+model.theta0);...
        -R*cos(croachPos(3)+model.theta0);...
        croachPos(3)]...
        +...
        [icc(1);...
        icc(2);...
        robot_omega*endT]; %croachPos(3)]  % before it was robot_omega here
elseif (v_l == v_r) && (v_l == 0)
    croachPos = croachPos';
else
    robot_omega = 0;
    croachPos = croachPos' + ...
        [v_l*cos(croachPos(3)+model.theta0)*endT; ... % RECHECK THIS!! IT should be like SMOOTH
        v_l*sin(croachPos(3)+model.theta0)*endT; ... % v_l * sin(croachPos(3)) according to eq. not cos(croachPos(3)/v_l
        0];
end
croachPos = croachPos';
end
