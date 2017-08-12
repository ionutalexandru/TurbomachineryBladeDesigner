function Message = DeleteProfile(Name, type)
%DELETEPROFILE Summary of this function goes here
%   Detailed explanation goes here
%   It receives as input the profile name that 
%   it will be deleted
%   It also updates the listbox names

ProfileName = ['./ThicknessProfiles/ThicknessProfiles',type,'.dat'];
Profiles = importdata(ProfileName);
FileName = ['./ThicknessProfiles/',Name,'.dat'];

delete(FileName);
n=1;
Continue = 'True';
while  isequal(Continue, 'True')
    if isequal(Profiles{n},Name)
        Continue = 'False';
        break;
    else
        n = n+1;
    end
end

m = numel(Profiles);

if n>1
   for i = 1:n-1
      Profiles1{i,1} = Profiles{i,1}; 
   end
   if m>n
      for j = n+1:m
         Profiles1{j-1,1} = Profiles{j,1}; 
      end
   end
else
    for i = 2:m
        Profiles1{i-1,1} = Profiles{i,1};
    end
end

Profiles = Profiles1;
m = numel(Profiles);

fileID = fopen(ProfileName,'w');
for i = 1:m
   fprintf(fileID,'%s',Profiles{i,1});
   fprintf(fileID,'\n');
end
fclose(fileID);

Message = 'Profile was successfully deleted';
end