function Message = SaveProfile(x, thick, Name )
%SAVEPROOFILE Summary of this function goes here
%   Detailed explanation goes here
%   It receives as inputs:
%   -   Message: whether there exist errors
%   -   x distribution
%   -   y distribution
%   What it does is to:
%   1. Update ThicknessProfileTurbine/Compressor
%   2. Save as txt file the profile

Data(1,:) = x;
Data(2,:) = thick;
FileName = ['./ThicknessProfiles/',Name,'.dat'];
ProfileName = ['./ThicknessProfiles/','ThicknessProfiles.dat'];

fileID = fopen(FileName,'wt');
for i = 1:2
   fprintf(fileID, '%g \t', Data(i,:));
   fprintf(fileID,'\n');
end
fclose(fileID);

ThicknessProfile = importdata(ProfileName);
ThicknessProfile{numel(ThicknessProfile)+1} = Name;

fileID = fopen(ProfileName,'w');
for i = 1:numel(ThicknessProfile)
   fprintf(fileID,'%s',ThicknessProfile{i});
   fprintf(fileID,'\n');
end
fclose(fileID);

Message = 'Profile was successfully added';
end

