function Results = PlottingExtras(MetalInlet, MetalOutlet, Stagger, yc_ult)
%PLOTTINGEXTRAS Summary of this function goes here
%   Detailed explanation goes here
%   This function receive as inputs:
%       Inlet Camber Angle
%       Outlet Camber Angle
%       Stagger Angle
%       Camber Last coordinate
%   and retrieves a series of coordinates that are employed to
%   plot Camber Angles, Stagger and Camber Angle

%% Metal Angles

xc_ult = cosd(Stagger);

%% Inlet
x_IN = (tand(MetalOutlet)*xc_ult + yc_ult)/(tand(MetalInlet) + tand(MetalOutlet));
n = 1000;
x1 = linspace(-0.25*cosd(MetalInlet),x_IN+0.15*cosd(MetalInlet),n);
y1 = tand(MetalInlet)*x1;
RInlet(1,:) = x1;
RInlet(2,:) = y1;
Results{1} = RInlet;

% Angle Curve
rCurve = 0.1;
angle1 = linspace(0,MetalInlet,n);
xCurve1 = -rCurve*cosd(angle1);
yCurve1 = -rCurve*sind(angle1);
Curve1(1,:) = xCurve1;
Curve1(2,:) = yCurve1;
Results{2} = Curve1;

%% Outlet
x2 = linspace(x_IN-0.15*cosd(MetalOutlet),xc_ult+0.15*cosd(MetalOutlet),n);
y2 = tand(MetalOutlet)*(xc_ult-x2) + yc_ult;
Line2(1,:) = x2;
Line2(2,:) = y2;
Results{3} = Line2;

%Horizontal Line
x3 = linspace(xc_ult-0.05,xc_ult+0.25,n);
y3 = yc_ult*ones(1,n);
Line3(1,:) = x3;
Line3(2,:) = y3;
Results{4} = Line3;

% Curve
angle2 = linspace(0, MetalOutlet, n);
Curve2(1,:) = cosd(angle2)*rCurve+xc_ult;
Curve2(2,:) = yc_ult-sind(angle2)*rCurve;
Results{5} = Curve2;

%% Camber Angle
x1 = rCurve*cosd(angle1)+x_IN;
y1 = rCurve*sind(angle1)+tand(MetalInlet)*x_IN;
x2 = rCurve*cosd(angle2)+x_IN;
y2 = tand(MetalInlet)*x_IN - rCurve*sind(angle2);
Curve3(1,:) = [fliplr(x1) x2];
Curve3(2,:) = [fliplr(y1) y2];
Results{6} = Curve3;

end

