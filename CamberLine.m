function [Results] = CamberLine( MetalAngle1, MetalAngle2, Stagger, Option )
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
if isequal(Option,'T')
    P3 = [cosd(Stagger) -sind(Stagger)];
else
    P3 = [cosd(Stagger) sind(Stagger)];
end

% Determination of P2

if isequal(Option, 'T')
    P2(1) = (tand(MetalAngle2)*P3(1)+P3(2))/(tand(MetalAngle2) + tand(MetalAngle1));
else
   P2(1) = (-tand(MetalAngle2)*P3(1)+P3(2))/(-tand(MetalAngle2) + tand(MetalAngle1));
end
P2(2) = tand(MetalAngle1)*P2(1);


P = [P1(1) P1(2); P2(1) P2(2); P3(1) P3(2)];

%% Bezier curve

Bezier = BezierCurve(P,3);


%% Results Matrix
Results(1,:) = Bezier(:,1); %X-Camber
Results(2,:) = Bezier(:,2); %Y-Camber
end
