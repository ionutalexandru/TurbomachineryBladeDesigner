function [Results] = CamberLine( camber_angle_1, camber_angle_2, Stagger )
%BEZIER_3 Summary of this function goes here
%   This function deliver the camber line of the profile
%   taking as chord length = 1 and plotting the chord with Bèzier
%   having 3 control points:
%       LE, which will be considered to be 0,0
%       TE, which will be considered to be Cax,0
%       camber angles, whose intersection lines
%           deliver the third control point
%   Output matrix R:
%       1st row: X coord without Stagger
%       2nd row: Y coord without Stagger
%       3rd row: X' coord with Stagger
%       4th row: Y' coord with Stagger

P1 = [0 0];
P3 = [1 0];

% Determination of P2
P2(1) = 1/(1+tand(camber_angle_1)/tand(camber_angle_2));
P2(2) = tand(camber_angle_1)*P2(1);

%% Bezier curve
num = 1000;
t = linspace(0,1,num);
X1 = (1-t).^2*P1(1)+2*t.*(1-t)*P2(1)+t.^2*P3(1);
Y1 = (1-t).^2*P1(2)+2*t.*(1-t)*P2(2)+t.^2*P3(2);

%% Rotate the camber line about Z and at an angle=stagger

Stagger = -Stagger;
R = [cosd(Stagger) -sind(Stagger);sind(Stagger) cosd(Stagger)];
    for i = 1:num
       V = R*[X1(i) Y1(i)]';
       X2(i) = V(1);
       Y2(i) = V(2);
    end

%% Results Matrix
Results(1,:) = X1;
Results(2,:) = Y1;
Results(3,:) = X2;
Results(4,:) = Y2;
end
