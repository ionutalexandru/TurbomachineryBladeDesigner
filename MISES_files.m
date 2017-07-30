function [] = MISES_files(BladeName, Option, InletAngle, Mout, REin, Min)
%MISES Summary of this function goes here
%   Detailed explanation goes here:
%   This function creates the files to run MISES
%   Inputs:
%       -   sasd
%       -   sdas
%   Outputs:
%       -   sdf7

%% Create a copy of the RAW folder into a new one
FolderName = strcat('./Mises_Files/Mises_',BladeName);
mkdir(FolderName);
copyfile('./Mises_Files/Raw',FolderName);

%% Load files to Matlab
if isequal(Option, 'T')
    Source1 = 'T106A';
else
    Source1 = 'NACA_651210';
end
FolderSource = strcat(FolderName,'/', Source1);
cd(FolderSource);

% Modify ises
delete 'ises.t106'
if isequal(Option, 'T')
    fileID = fopen('ises.t106','a+');
else
    fileID = fopen('ises.naca','a+');
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

end

