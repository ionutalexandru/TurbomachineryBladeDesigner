function Results = BladeProfile(Xc, Yc, Thickness_Profile, Stagger, Max_Thick)
%	Blade_profile Summary of this function goes here:
%	Inputs:
%		X coordinates of the camber line
%		Y coordinates of the camber line
%		Thickness_Profile - to be chosen by the user
%	Results Output matrix
%   To implement a botton with which we save the coordinates without last
%   two coordinates - open blade profile


%% Load profile
ProfileFileName = strcat(Thickness_Profile,'.txt');
Thickness = load(ProfileFileName); 
%Multiplied by the chord length = 1
xt = Thickness(1,:)/100;
t = Thickness(2,:)/100; %Multiply by the chord 1
tmax = max(t);
ScallingFactor = Max_Thick/tmax;
t = t*ScallingFactor;

%% Differentiation vectors
diffX = zeros(1,numel(Xc)-1);
diffY = zeros(1,numel(Xc)-1);
thetac = zeros(1,numel(Xc));
diffX = diff(Xc);
diffY = diff(Yc);
thetac = [0.01 atand(diffY./diffX)];

%% Redefine Thickness Profile with Xc
t = interp1(xt,t,Xc,'pchip');

%% Pressure Surface (upper)
xa = Xc - t.*sind(thetac); % It goes from 0 to 1
ya = Yc + t.*cosd(thetac);

%% Suction Surface
xb = Xc + t.*sind(thetac); % It goes from 0 to 1
yb = Yc - t.*cosd(thetac);

Stagger = -Stagger;
R = [cosd(Stagger) -sind(Stagger);sind(Stagger) cosd(Stagger)];
    for i = 1:numel(xa)
       V = R*[xa(i) ya(i)]';
       xa(i) = V(1);
       ya(i) = V(2);
    end
    
    for i = 1:numel(xa)
       V = R*[xb(i) yb(i)]';
       xb(i) = V(1);
       yb(i) = V(2);
    end

%% Final X coordinates vector of the blade has to go from 1 to 1
% Same as Y

Results{1,:} = [fliplr(xb) xa(2:numel(xa))];
Results{2,:} = [fliplr(yb) ya(2:numel(ya))];
Results{3,:} = Xc;
Results{4,:} = t;
end
