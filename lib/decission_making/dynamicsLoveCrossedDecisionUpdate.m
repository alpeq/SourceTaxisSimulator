function [croachPos] = dynamicsLoveCrossedDecisionUpdate(croachPos, inL, deL, inR, deR, normOdourL, normOdourR, alpha, sM, kI, kD, kN)
% DYNAMICSLOVECROSSEDDECISIONUPDATE stimulus sensory-motor connection and 
% agent update based on differential drive model.
%
%   Sensory-motor connection Braitenberg dynamic type 3 Love 
%   v = alpha*( SM - kN*contribution) 
%   contributionLEFT = kI*inRIGHT + kD*decreasesRIGHT + kN*normOdorLEFT;
%   contributionRIGHT = kI*increasesLEFT + kD*deLEFT + kN*normOdorRIGHT;
%   dynamicsLoveCrossedDecisionUpdate(croachPos, inL, deL, inR, deR, 
%                           normOdorL, normOdorR, alpha, sM, kI, kD, kN)
%   -> croachPos: inital position
%   -> normOdourL: odour concentration from left sensory appendage
%   -> normOdourR: odour concentration from right sensory appendage
%   -> alpha: velocity scaling factor
%   -> sM: maximun sensory value of the value
%   -> kI: ON neuron, increase stimulus scaling factor
%   -> kD: OFF neuron, decreases stimulus scaling factor
%   -> kN: stimulus scaling factor
%   <- croachPos: new position in time
%
% See also: braitenbergDecisionUpdate, braitenbergLoveDecisionUpdate,
% dynamicsDecsionUpdate, dynamicsLoveDecisionUpdate, 
% dynamicsLoveCrossedDecsionUpdate
%

global model
global endT

g = sM * endT;


contributionL = kI*inR + kD*deR + kN*normOdourL;
contributionR = kI*inL + kD*deL + kN*normOdourR;


% Braitenberg model 3: Love
v_l = alpha*( g - contributionL);
v_r = alpha*( g - contributionR);


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
        robot_omega*endT];
elseif (v_l == v_r) && (v_l == 0)
    croachPos = croachPos';
else
    robot_omega = 0;
    croachPos = croachPos' + ...
        [v_l*cos(croachPos(3)+model.theta0)*endT; ... %cos(croachPos(3)/v_l)
        v_l*sin(croachPos(3)+model.theta0)*endT; ...
        0];
end
croachPos = croachPos';
end
