function [ LE, Camber, TE, Camber2, Curve1, Curve2, Curve3, Curve4, CP_Bezier ] = BladeManual( MetalInlet, MetalOutlet, Stagger, a, b, phi_LESS, phi_LEPS, phi_TESS, phi_TEPS, rTE, s_c, o_c, t_c, phi_o, phi_t )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   This is for a turbine

%% Obtain Camber Line
Camber = CamberLine(MetalInlet, MetalOutlet, Stagger, 'T');

%% Leading Edge
n = 100;
% Upper ellipe
phi1 = linspace(0, phi_LESS, n);
x1 = a - a*cosd(phi1);
y1 = b*sind(phi1);

% Lower ellipe
phi2 = linspace(0, phi_LEPS, n);
x2 = a - a*cosd(phi2);
y2 = -b*sind(phi2);

LEx = [fliplr(x2(1:n-1)) x1];
LEy = [fliplr(y2(1:n-1)) y1];

LE = [LEx; LEy];

% Rotation of the ellipse at Metal Inlet
R = [cosd(MetalInlet) -sind(MetalInlet); sind(MetalInlet) cosd(MetalInlet)]; % Rotation Matrix - rotate Metal Inlet ccw
LE = R*LE;

%% Trailing Edge
% Upper circunference
phi3 = linspace(180,180-phi_TESS,n);
x3 = -rTE-rTE*cosd(phi3);
y3 = rTE*sind(phi3);

% Lower cirunference
phi4 = linspace(180,180-phi_TEPS,n);
x4 = -rTE-rTE*cosd(phi4);
y4 = -rTE*sind(phi4);

TEx = [fliplr(x4(2:n-1)) x3];
TEy = [fliplr(y4(2:n-1)) y3];

TE = [TEx; TEy];

% Rotation of the cirunference at Metal Outletv
R = [cosd(-MetalOutlet) -sind(-MetalOutlet); sind(-MetalOutlet) cosd(-MetalOutlet)]; % Rotation Matrix - rotate Metal Outlet cw
TE = R*TE;

% Change the position of the circle
TE = TE + [Camber(1,1001); Camber(2,1001)];

%% Control Points of LE and TE
CP1_PS = [LE(1,1), LE(2,1)];
CP1_SS = [LE(1,199), LE(2,199)];

CP5_PS = [TE(1,1), TE(2,1)];
CP5_SS = [TE(1,199), TE(2,199)];

CP_Bezier = [CP1_PS; CP1_SS; CP5_PS; CP5_SS];

%% Obtain the second control point

Camber2 = Camber + [0; s_c/2]; % Add s/2 to the camber line
CP = [Camber(1,1001) s_c + Camber(2,1001)]; % TE of the upper cascade blade
differ(1,:) = CP(1) - Camber2(1,:); % vector that goes from Camber 2 to CP
differ(2,:) = CP(2) - Camber2(2,:); % vector that goes from Camber 2 to CP
distance = sqrt((differ(1,:)).^2+(differ(2,:)).^2); % distance of vector that goes from Camber 2 to CP
[~, I] = min(distance); % Segment that passes through CP and perp to Camber2 has the min distance
IP = [differ(1,I), differ(2,I)];
slope = IP(2)/IP(1);
Angle = atand(slope);
CP3_SS = [CP(1) - o_c*cosd(Angle) CP(2) - o_c*sind(Angle)];
CP3_PS = [CP3_SS(1) - t_c*cosd(Angle) CP3_SS(2) - t_c*sind(Angle)];
CP_Bezier = [CP_Bezier; CP3_SS; CP3_PS];

%% Obtain second control point
CP2_SS = IntersectionPoint(CP1_SS(1), CP3_SS(1), CP1_SS(2), CP3_SS(2), (LE(2,199)-LE(2,198))/(LE(1,199)-LE(1,198)), -tand(phi_o));
CP2_PS = IntersectionPoint(CP1_PS(1), CP3_PS(1), CP1_PS(2), CP3_PS(2), (LE(2,2)-LE(2,1))/(LE(1,2)-LE(1,1)), -tand(phi_t));
P1SS = [CP1_SS; CP2_SS; CP3_SS];
P2PS = [CP1_PS; CP2_PS; CP3_PS];

%% Obtain the fourth intersection point 
CP4_SS = IntersectionPoint(CP3_SS(1), CP5_SS(1), CP3_SS(2), CP5_SS(2), -tand(phi_o), (TE(2,199)-TE(2,198))/(TE(1,199)-TE(1,198)));
CP4_PS = IntersectionPoint(CP3_PS(1), CP5_PS(1), CP3_PS(2), CP5_PS(2), -tand(phi_t), (TE(2,2)-TE(2,1))/(TE(1,2)-TE(1,1)));
P3SS = [CP3_SS; CP4_SS; CP5_SS];
P4PS = [CP3_PS; CP4_PS; CP5_PS];

CP_Bezier = [CP_Bezier; CP2_SS; CP2_PS; CP4_SS; CP4_PS];

%% Obtain Bezier curves
Curve1 = BezierCurve(P1SS,3)';
Curve2 = BezierCurve(P2PS,3)';
Curve3 = BezierCurve(P3SS,3)';
Curve4 = BezierCurve(P4PS,3)';
end

