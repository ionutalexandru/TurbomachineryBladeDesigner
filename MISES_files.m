function [] = MISES_files(BladeName, Option, Metal1, Metal2, pitch_ratio, Stagger, InletAngle, Mout, REin, Min, BladeProfile)
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
n=150;
Angle = linspace(0,180,n);
cax = cosd(Stagger);
Bladex_new = cax/2 - cax/2*cosd(Angle);

Bladex1 = fliplr(BladeProfile(1:index,1)');
Bladex2 = BladeProfile(index:m,1)';
Bladey1 = fliplr(BladeProfile(1:index,2)');
Bladey2 = BladeProfile(index:m,2)';

[Bladex1, index1]  = unique(Bladex1);
[Bladex2, index2]  = unique(Bladex2);

Bladey1_new = interp1(Bladex1,Bladey1(index1),Bladex_new,'pchip');
Bladey2_new = interp1(Bladex2,Bladey2(index2),Bladex_new,'pchip');

BladeProfile = zeros(2,2*n-1);
BladeProfile(1,:) = [fliplr(Bladex_new) Bladex_new(2:end)];
BladeProfile(2,:) = [fliplr(Bladey1_new) Bladey2_new(2:end)];
BladeProfile = BladeProfile';

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
Line{1} = strcat('1 2 5 6 15');
Line{2} = strcat('1 3 4 6 18');
if isequal(Option, 'T')
    Line{3} = [' 0.0000 0.0000 ',num2str(tand(InletAngle)),' -0.90732068 | Minl P1/Po1 Sinl Xinl'];
    Line{4} = [' ', num2str(Mout),' 0.790126628 -1.97966 1.46529265 | MOUT P2/Po1 Sout Xout'];
else
    Line{3} = [num2str(Min), ' 0.0000 ',num2str(tand(InletAngle)),' -0.90732068 | Minl P1/Po1 Sinl Xinl'];
    Line{4} = ' 0.400000 0.790126628 -1.97966 1.46529265 | MOUT P2/Po1 Sout Xout';
end
Line{5} = strcat(' 0.0000 0.0000   |mfr');
Line{6} = [num2str(REin),' -0.8 | REYin ACRIT'];
Line{7} = strcat(' 1.01  1.01 | XTR1 XTR2');
Line{8} = strcat(' 1 0.95 +1.0 |ISMOM MCRIT MUCON');
Line{9} = strcat(' 0.0 0. | Bvr1 Bvr2');
if isequal(Option, 'T')
    Line{10} = strcat(' 0. 0.  0. 0. 0. 0. 0. 0. 0. 0. 0.');
else
   Line{10} = '0. 0. 0. 35.0'; 
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
    Line1{2} = [' ',num2str(tand(Metal1)),'   -',num2str(tand(Metal2)),'    1.00000     1.00000     ',num2str(pitch_ratio)];
else
    Line1{1} = 'XBLADE V6.1.5';
    Line1{2} = [' ',num2str(tand(Metal1)),'   -',num2str(tand(Metal2)),'   0.50000000   0.50000000   ',num2str(pitch_ratio)];
end
[m,~] = size(BladeProfile);
for i = 1:m
   Line1{i+2} = ['    ',num2str(BladeProfile(i,1)),'       ',num2str(BladeProfile(i,2))];
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

