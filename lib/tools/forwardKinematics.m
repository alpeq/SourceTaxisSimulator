function [PointsL,PointsR, TipL, TipR]=forwardKinematics(posCroach, osciTipL, osciTipR, model, antennae)
% FORWARDKINEMATICS obtained the position of the tip of the antennae based 
% on the state of the antennae in the oscillator
%
% forwardKinematics(posCroach, osciTipL, osciTipR, model, antennae)


l1 = model.l1;
l2 = model.l2;
l3 = model.l3;
theta0 = model.theta0;
theta12l = model.theta12l;
theta12r = model.theta12r;
theta3l = model.theta3l;
theta3r = model.theta3r;
ampLeft = antennae.ampLeft;
ampRight = antennae.ampRight;

% Initial position
x1 = posCroach(1); 
y1 = posCroach(2);
theta1 = posCroach(3); 


Xl =x1 + l1 * cos(theta0 + theta1) + l2 * cos(theta0 + theta1 + theta12l) + l3 * cos(theta0 + theta1 + theta3l); % compute x coordinates
Yl =y1 + l1 * sin(theta0 + theta1) + l2 * sin(theta0 + theta1 + theta12l) + l3 * sin(theta0 + theta1 + theta3l); % compute y coordinates

Xr =x1 + l1 * cos(theta0 + theta1) + l2 * cos(theta0 + theta1 + theta12r) + l3 * cos(theta0 + theta1 + theta3r); % compute x coordinates
Yr =y1 + l1 * sin(theta0 + theta1) + l2 * sin(theta0 + theta1 + theta12r) + l3 * sin(theta0 + theta1 + theta3r); % compute y coordinates

PointsL = [Xl' Yl'];
PointsR = [Xr' Yr'];

% Interpolation in the range of the oscillator amp -> -amp  : 2amp
xl = linspace(ampLeft, -ampLeft, numel(theta3l));
xr = linspace(ampRight, -ampRight, numel(theta3r));

try
    angL = interp1(xl,theta3l,max(min(osciTipL,xl(1)),xl(end)),'linear');
catch InterpolaError
    angL = theta3l(1);
end
try   
    angR = interp1(xr,theta3r,max(min(osciTipR,xr(1)),xr(end)),'linear');
catch
    angR = theta3r(1);
end



if osciTipL < -ampLeft
    angL = theta3l(1);
elseif osciTipL > ampLeft
    angL = theta3l(end);
end

if osciTipR < -ampRight
    angR = theta3r(1);
elseif osciTipR > ampRight
    angR = theta3r(end);
end

tl_x =x1 + l1 * cos(theta0 + theta1) + l2 * cos(theta0 + theta1 + theta12l) + l3 * cos(theta0 + theta1 + angL); % compute x coordinates
tl_y =y1 + l1 * sin(theta0 + theta1) + l2 * sin(theta0 + theta1 + theta12l) + l3 * sin(theta0 + theta1 + angL); % compute y coordinates

tr_x =x1 + l1 * cos(theta0 + theta1) + l2 * cos(theta0 + theta1 + theta12r) + l3 * cos(theta0 + theta1 + angR); % compute x coordinates
tr_y =y1 + l1 * sin(theta0 + theta1) + l2 * sin(theta0 + theta1 + theta12r) + l3 * sin(theta0 + theta1 + angR); % compute y coordinates

TipL = [tl_x tl_y]; % It supposed to be one point
TipR = [tr_x tr_y];

end
