function [croachPos] = braitenbergDecisionUpdate(croachPos, odorL, odorR)
global l1
global theta0 
global endT

% if odorL > odorR
%     disp('LEFT DIR')
% elseif odorL < odorR
%     disp('RIGHT DIR')
% else
%     disp('Straight Line')
%end
kl = 0.7*3; %With 2 it is moving but with jumps scaling factor of the sensory connection to the left motor 0.02 when sumOdor
kr = 0.7*3; % scaling factor of the sensory connection to the right motor

cross_coupling = 1; % determines whether to make a cross-coupling or not
                    % 1 = cross-coupling, 0 = no cross-coupling

    % Braitenberg model
    if (cross_coupling == 1)
        v_l = kl*odorR;
        v_r = kr*odorL;
    else
        v_l = kl*odorL;
        v_r = kr*odorR;
    end
    
    v_l =v_l;%*(10^4);
    v_r =v_r;%*(10^4);
        % Calculate power difference of left and right side outputs
%         diff_LR = outL1-outR1;
% v_high = 3; % velocity of the faster wheel
% v_low = 1;  % velocity of the slower wheel
%         if (diff_LR > 0)
%           v_l = v_low;
%           v_r = v_high;
%         elseif (diff_LR < 0)
%           v_l = v_high;
%           v_r = v_low;
%         else
%           v_r = v_high;
%           v_l = v_high;
%         end
    %v_l = 1; v_r = 1;
    if (v_l ~= v_r)
        R = (l1)*(v_r + v_l)/(v_r - v_l);
        robot_omega = (v_r - v_l)/(l1*2) ;
        icc = [croachPos(1) - (R*sin(croachPos(3)+theta0)), ...
               croachPos(2) + (R*cos(croachPos(3)+theta0))];
%         croachPos = [cos(robot_omega) -sin(robot_omega) 0;...
%                       sin(robot_omega)  cos(robot_omega) 0;...
%                       0                 0                1]...
%                       *...
%                       [R*sin(croachPos(3));...
%                       -R*cos(croachPos(3));...
%                       croachPos(3)]...
%                       +...
%                       [icc(1);...
%                       icc(2);...
%                      robot_omega]; %croachPos(3)]  % before it was robot_omega here
        croachPos = [cos(robot_omega*endT) -sin(robot_omega*endT) 0;...
                      sin(robot_omega*endT)  cos(robot_omega*endT) 0;...
                      0                 0                1]...
                      *...
                      [R*sin(croachPos(3)+theta0);...
                      -R*cos(croachPos(3)+theta0);...
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
    % DEBUG
    %  v_l
    %  v_r
    croachPos = croachPos';
end
