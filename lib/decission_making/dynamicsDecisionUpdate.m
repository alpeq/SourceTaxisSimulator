function [croachPos] = dynamicsDecisionUpdate(croachPos, inL, deL, inR, deR, normOdorL, normOdorR)
global l1
global theta0 

global D_inL
global D_deL
global D_noL
global D_totL

global D_inR
global D_deR
global D_noR
global D_totR

global endT 

a = 0.2; %;0.008; %0.006With 2 it is moving but with jumps scaling factor of the sensory connection to the left motor 0.02 when sumOdor
cross_coupling = 1; % determines whether to make a cross-coupling or not
                    % 1 = cross-coupling, 0 = no cross-coupling


ki = 0.33 *2;
kd = 2*ki;
kn = 0.33;
                        
                    
    % Dynamic of the plume model, based on neurons paper in the cockroach
    % decrements are more sensitive than decrements
    
     contributionL = ki*inL + kd*deL + kn*normOdorL;
     contributionR = ki*inR + kd*deR + kn*normOdorR;
     D_inL = [D_inL inL];
     D_deL = [D_deL deL];
     D_noL = [D_noL normOdorL];
     D_totL = [D_totL contributionL];
     D_inR = [D_inR inR];
     D_deR = [D_deR deR];
     D_noR = [D_noR normOdorR];
     D_totR = [D_totR contributionR];
     
%      contributionL = 1*inL + 1.2*deL + normOdorL;
%      contributionR = 1*inR + 1.2*deR + normOdorR;  with static antennae
    if (cross_coupling == 1)
        v_l = a*contributionR;
        v_r = a*contributionL;
    else
        v_l = a*contributionL;
        v_r = a*contributionR;
    end
    

    if (v_l ~= v_r)
        R = (l1)*(v_r + v_l)/(v_r - v_l);
        robot_omega = (v_r - v_l)/(l1*2) ;
        icc = [croachPos(1) - (R*sin(croachPos(3)+theta0)), ...
               croachPos(2) + (R*cos(croachPos(3)+theta0))];

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
    % DEBUG
    %  v_l
    %  v_r
    croachPos = croachPos';
end