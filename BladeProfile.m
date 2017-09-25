function Results = BladeProfile(ThicknessProfileName, Max_Thick, Xc, Yc, Stagger, Option)
%	Blade_profile Summary of this function goes here:
%	Inputs:
%		X coordinates of the camber line
%		Y coordinates of the camber line
%		Thickness_Profile - to be chosen by the user
%	Results Output matrix
%   To be noted that chord length is 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Thickness
ProfileFileName = strcat('./ThicknessProfiles/',ThicknessProfileName, '.dat');
ThicknessRaw = load(ProfileFileName)/100; % Load profile
Xc1 = linspace(ThicknessRaw(1,2),1,1000); % For presentations purposes
t2 = interp1(ThicknessRaw(1,2:end),ThicknessRaw(2,2:end),Xc1,'pchip');
anglett = linspace(0,90,10);
b = ThicknessRaw(2,2);
a = ThicknessRaw(1,2);
tt1(1,:) = a - a*cosd(anglett);
tt1(2,:) = b*sind(anglett);
for i=1:10
   t1(1,i) = tt1(1,i);
   t1(2,i) = tt1(2,i);
end
for i = 11:numel(t2)
   t1(1,i) = Xc1(i-9);
   t1(2,i) = t2(i-9);
end

% Scalling factor
tmax = max(t1(2,:)); %Maximum Thickness Value
ScallingFactor = Max_Thick/tmax; % Scalling Factor


%% Differential Vectors
if isequal(Option, 'T')
    R = [cosd(Stagger) -sind(Stagger); sind(Stagger) cosd(Stagger)];
else
    R = [cosd(-Stagger) -sind(-Stagger); sind(-Stagger) cosd(-Stagger)];
end

for i = 1:numel(Xc)
    x = Xc(i);
    y = Yc(i);
    v = [x; y];
   V = R*v;
   Xc(i) = V(1);
   Yc(i) = V(2);
end
diffX = diff(Xc);
diffY = diff(Yc);
thetac = [0 atand(diffY./diffX)]; % First Value 0 and ThetaC definition

%% Redefine Thickness distribution according with Xc coordinations
t2 = ScallingFactor*interp1(t1(1,:),t1(2,:),Xc,'pchip');

%% Pressure Surface (upper)
xa = Xc - t2.*sind(thetac); % It goes from 0 to 1
ya = Yc + t2.*cosd(thetac);

%% Suction Surface
xb = Xc + t2.*sind(thetac); % It goes from 0 to 1
yb = Yc - t2.*cosd(thetac);

% %% Rotate
if isequal(Option, 'T')
    R = [cosd(-Stagger) -sind(-Stagger);sind(-Stagger) cosd(-Stagger)];
else
    R = [cosd(Stagger) -sind(Stagger); sind(Stagger) cosd(Stagger)];
end

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

% Store X Y
Results{1,:} = [fliplr(xb(1:numel(xb)-1)) xa(2:numel(xa)-1)];
Bladex = [fliplr(xb(1:numel(xb)-1)) xa(2:numel(xa)-1)]';
Results{2,:} = [fliplr(yb(1:numel(yb)-1)) ya(2:numel(ya)-1)];
Bladey = [fliplr(yb(1:numel(yb)-1)) ya(2:numel(ya)-1)]';
% Store Xc1 and t1
Results{3,:} = t1(1,:); % Save into Results variable
Results{4,:} = ScallingFactor*t1(2,:); % Save into Results variable

%% Save everything into a file
BladeFile = ['./Blade/Blade',Option,'.dat'];
fileID = fopen(BladeFile,'w+');
for i = 1:numel(Bladex)
    fprintf(fileID, '%g\t%g\n', Bladex(i,1), Bladey(i,1));
    fprintf(fileID, '\n');
end
fclose(fileID);
end