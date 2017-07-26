function [ LE, Camber ] = BladeManual( MetalInlet, MetalOutlet, Stagger, a, b, phi_LESS, phi_LEPS )
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
CP1_SS = [x1(n), y1(n)];

% Lower ellipe
phi2 = linspace(0, phi_LEPS, n);
x2 = a - a*cosd(phi2);
y2 = -b*sind(phi2);
CP1_PS = [x2(n), y2(n)];

LEx = [fliplr(x2(1:n-1)) x1];
LEy = [fliplr(y2(1:n-1)) y1];

LE = [LEx; LEy];

% Rotation of the ellipse at Metal Inlet
R = [cosd(MetalInlet) -sind(MetalInlet); sind(MetalInlet) cosd(MetalInlet)]; % Rotation Matrix - rotate Metal Inlet ccw
LE = R*LE;

%% Trailing Edge

end

