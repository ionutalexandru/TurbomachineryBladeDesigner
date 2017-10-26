function [] = MISES_files(BladeName, Option, Metal1, Metal2, pitch_ratio, Stagger, InletAngle, Mout, REin, Min, BladeProfile, opt)
%MISES Summary of this function goes here
%   Detailed explanation goes here:
%   This function creates the files to run MISES
%   Inputs:
%       -   BladeName: Decided by the user
%       -   Option: T or C
%       -   InletAngle, Mout, REin, Min and BladeProfile: MISES inputs
%   Outputs:
%       -   ises and blade: modify them and generate new ones

%% Create a copy of the RAW folder into a new one
cd('Mises_Files');
FolderName = strcat('./Mises_Files/Mises_',BladeName);
Folder = strcat('Mises_',BladeName);
Content = ls;
[m, ~] = size(Content);
for i = 1:m
   if isequal(Folder, Content(m,:))
       delete Folder
       break;
   end
end
cd('..');
mkdir(FolderName);
copyfile('./Mises_Files/Raw',FolderName);

%% Modify Blade Profile
% Move to the left the blade profile in order to have positive coordinates
[min_x, ~]  = min(BladeProfile(:,1));
BladeProfile(:,1) = BladeProfile(:,1) + abs(min_x);
[~, index]  = min(BladeProfile(:,1));
m = numel(BladeProfile(:,1));
n=65;
Angle = linspace(0,180,n);
cax = cosd(Stagger);
Bladex_new = cax/2 - cax/2*cosd(Angle);

Bladex1 = fliplr(BladeProfile(1:index,1)');
Bladex2 = BladeProfile(index:m,1)';
Bladey1 = fliplr(BladeProfile(1:index,2)');
Bladey2 = BladeProfile(index:m,2)';

[Bladex1, index1]  = unique(Bladex1);
[Bladex2, index2]  = unique(Bladex2);

Bladey1_new = fliplr(interp1(Bladex1,Bladey1(index1),Bladex_new,'pchip'));
Bladex1_new = fliplr(Bladex_new);
Bladey2_new = interp1(Bladex2,Bladey2(index2),Bladex_new,'pchip');
minn = min(Bladey2_new);
Bladey1_new = Bladey1_new + minn;
Bladey2_new = Bladey2_new + minn;

if opt == 1
    BladeProfile = zeros(2,2*n-4);
    BladeProfile(1,:) = [Bladex1_new(4:end) Bladex_new(2:end)]; %Blade Manual 2 -- -1 --> -2
    BladeProfile(2,:) = [Bladey1_new(4:end) Bladey2_new(2:end)];
elseif opt == 2
    BladeProfile = zeros(2,2*n-6);
    BladeProfile(1,:) = [Bladex1_new(3:end) Bladex_new(2:end-3)]; %Blade Manual 2 -- -1 --> -2
    BladeProfile(2,:) = [Bladey1_new(3:end) Bladey2_new(2:end-3)];
else
    BladeProfile = zeros(2,2*n-1);
    BladeProfile(1,:) = [Bladex1_new(1:end) Bladex_new(2:end)]; %Blade Manual 2 -- -1 --> -2
    BladeProfile(2,:) = [Bladey1_new(1:end) Bladey2_new(2:end)];
end

% BladeProfile = zeros(2,2*n-4);
% BladeProfile(1,:) = [Bladex1_new(4:end) Bladex_new(2:end)];
% BladeProfile(2,:) = [Bladey1_new(4:end) Bladey2_new(2:end)];
% BladeProfile = BladeProfile';

% Turbine: 3:end, 2:end-1 --> 2*n-4
% Compressor: 2:end, 2:end-1 --> 2*n-3
% Manual: 1:end, 2:end-1 ---> 2*n-2

%% Load files to Matlab
if isequal(Option, 'T')
    Source1 = 'T106A';
else
    Source1 = 'NACA_651210';
end
cd(FolderName)
if isequal(Option, 'T')
    rmdir('NACA_651210','s'); 
else
    rmdir('T106A','s'); 
end
cd(Source1);

% Modify ises
if isequal(Option, 'T')
    delete 'ises.t106'
    fileID = fopen('ises.t106','w+');
else
    delete 'ises.naca'
    fileID = fopen('ises.naca','w+');
end
if isequal(Option, 'T')
    Line{1} = strcat('1 2 5 6 15');
    Line{2} = strcat('1 3 4 6 17');
else
    Line{1} = strcat('1 2 5 15');
    Line{2} = strcat('1 3 4 15');
end

if isequal(Option, 'T')
<<<<<<< HEAD
    Line{3} = [' 0.3000 0.0000 ',num2str(tand(InletAngle)),' -0.40000 | Minl P1/Po1 Sinl Xinl'];
    Line{4} = [' ', num2str(Mout),' 0.00000 0.267949 1.40000 | MOUT P2/Po1 Sout Xout'];
=======
<<<<<<< HEAD
    Line{3} = [' 0.3000 0.0000 ',num2str(tand(InletAngle)),' -0.40000 | Minl P1/Po1 Sinl Xinl'];
    Line{4} = [' ', num2str(Mout),' 0.00000 0.267949 1.40000 | MOUT P2/Po1 Sout Xout'];
=======
    Line{3} = [' 0.3000 0.0000 ',num2str(tand(InletAngle)),' -0.250000 | Minl P1/Po1 Sinl Xinl'];
    Line{4} = [' ', num2str(Mout),' 0.00000 0.267949 1.250000 | MOUT P2/Po1 Sout Xout'];
>>>>>>> d61b8977713f8f67d533e7273d4fa9d552b323e9
>>>>>>> 8c7b181f42fe27ee96a33c8d1f377f95e3245a0e
else
    Line{3} = [num2str(Min), ' 0.1000 ',num2str(tand(InletAngle)),' -0.25 | Minl P1/Po1 Sinl Xinl'];
    Line{4} = ' 0.400000 0.790126628 -1.97966 1.25 | MOUT P2/Po1 Sout Xout';
end
Line{5} = strcat(' 0.0000 0.0000   |mfr');
if isequal(Option, 'T')
    Line{6} = [num2str(REin),' -0.8 | REYin ACRIT'];
<<<<<<< HEAD
    Line{7} = strcat(' 0.02  0.02 | XTR1 XTR2');
else
   Line{6} = [num2str(REin),' 4.500000 | REYin NCRIT'];
   Line{7} = ['1.10000  1.10000 | XTR1 XTR2'];
=======
<<<<<<< HEAD
    Line{7} = strcat(' 0.02  0.02 | XTR1 XTR2');
=======
    Line{7} = strcat(' 1.01  1.01 | XTR1 XTR2');
>>>>>>> d61b8977713f8f67d533e7273d4fa9d552b323e9
else
   Line{6} = [' 250000.000000 4.500000 | REYin NCRIT'];
   Line{7} = ['1.100000  1.100000 | XTR1 XTR2'];
>>>>>>> 8c7b181f42fe27ee96a33c8d1f377f95e3245a0e
end
Line{8} = strcat(' 1 0.95 +1.0 |ISMOM MCRIT MUCON');
Line{9} = strcat(' 0.0 0. | Bvr1 Bvr2');
if isequal(Option, 'T')
    Line{10} = strcat(' 0. 0.  0. 0. 0. 0. 0. 0. 0. 0. 0.');
else
   Line{10} = '0. 0. 0. 0.0'; 
end

for i = 1:numel(Line)
   fprintf(fileID, '%s\n',Line{i}); 
end

fclose(fileID);

% Modify blade

if isequal(Option, 'T')
    delete 'blade.t106'
    fileID1 = fopen('blade.t106','w+');
else
    delete 'blade.naca'
    fileID1 = fopen('blade.naca','w+');
end

if isequal(Option, 'T')
    Line1{1} = '   PERFIL T106';
    %Line1{2} = [' 0.77289   -1.97966    1.00000     1.00000     ',num2str(pitch_ratio)];

    Line1{2} = sprintf('%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t',tand(Metal1),tand(-Metal2),1,1,pitch_ratio);

    Line1{2} = sprintf('%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t',tand(Metal1),tand(-Metal2),1,1,pitch_ratio);

    Line1{2} = sprintf('%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t',tand(Metal1-12),tand(Metal2-10),1,1,pitch_ratio);

    %Line1{2} = [' ',num2str(tand(Metal1-12)),'   -',num2str(tand(Metal2-10)),'    1.00000     1.00000     ',num2str(pitch_ratio)];

else
    Line1{1} = 'XBLADE V6.1.5';
    %Line1{2} = [' 0.21255656   -1.97966   0.50000000   0.50000000   ',num2str(pitch_ratio)];

    Line1{2} = [' ',' ',num2str(tand(Metal1)),'   -',num2str(tand(Metal2)),'   0.50000000   0.50000000   ',num2str(pitch_ratio)];

    Line1{2} = [' ',' ',num2str(tand(Metal1)),'   -',num2str(tand(Metal2)),'   0.50000000   0.50000000   ',num2str(pitch_ratio)];

    Line1{2} = [' ',' ',num2str(tand(Metal1-10)),'   -',num2str(tand(Metal2-10)),'   0.50000000   0.50000000   ',num2str(pitch_ratio)];

end
[m,~] = size(BladeProfile);
for i = 1:m
   Line1{i+2} = sprintf('%.6f\t%.6f',BladeProfile(i,1),BladeProfile(i,2));
end

for i = 1:numel(Line1)
   fprintf(fileID1, '%s\n',Line1{i}); 
end

fclose(fileID1);

if isequal(Option,'T')
   filess = dir('*.t106'); 
else
    filess = dir('*.naca');
end
sizess = size(filess);
for i=1:sizess
   namess = filess(i).name;
   [token, ~] = strtok(namess,'.');
   New_file_name = [token, '.', BladeName];
   fileID2 = fopen(New_file_name,'w+');
   fclose(fileID2);
   copyfile(namess,New_file_name);
   delete(namess)
   copyfile(New_file_name,'..');
end
cd('..');
rmdir(Source1,'s');
cd('..');
cd('..');
end

