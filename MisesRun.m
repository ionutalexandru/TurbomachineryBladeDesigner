function MisesRun(BladeName, Route)
%MISESRUN Summary of this function goes here
%   Detailed explanation goes here

cd('Mises_Files');
cd(['Mises_' BladeName]);
%%% MeshMISES
File = 'meshMISES.scp';
fid = fopen(File, 'r+');
tmp = textscan(fid, '%s', 'Delimiter', '\n');
tmp = tmp{1,1};
Cont = 1;
j = 1;
while isequal(Cont,1)
    if strfind(tmp{j},'set ejecutable_iset="/opt/MisesUC3M/iset"')==1
        tmp{j} = ['set ejecutable_iset="', Route,'/iset"'];
        break;
    else
        j = j+1;
    end
end
fclose(fid);
fid = fopen(File, 'w+');
for ii = 1:numel(tmp)
   fprintf(fid,'%s',tmp{ii});
   fprintf(fid,'\n');
end
fclose(fid);
clear tmp
        
%%% postMISES
File = 'postMISES.scp';
fid = fopen(File, 'r+');
tmp = textscan(fid, '%s', 'Delimiter', '\n');
tmp = tmp{1,1};
Cont = 1;
j = 1;
while isequal(Cont,1)
    if strfind(tmp{j},'set ejecutable_mises="/opt/MisesUC3M/mises2.68"')==1
        tmp{j} = ['set ejecutable_mises="', Route,'/mises2.68"'];
        tmp{j+1} = ['set ejecutable_iplot="', Route,'/iplot"'];
        break;
    else
        j = j+1;
    end
end
fclose(fid);
fid = fopen(File,'w+');
for ii = 1:numel(tmp)
   fprintf(fid,'%s',tmp{ii});
   fprintf(fid,'\n');
end
fclose(fid);
clear tmp

%%% runMISES
File = 'runMISES.scp';
fid = fopen(File, 'r+');
tmp = textscan(fid, '%s', 'Delimiter', '\n');
tmp = tmp{1,1};
Cont = 1;
j = 1;   
while isequal(Cont,1)
    if strfind(tmp{j},'set ejecutable_ises="/opt/MisesUC3M/ises"')==1
        tmp{j} = ['set ejecutable_ises="', Route,'/ises"'];
        tmp{j+1} = ['set ejecutable_iset="', Route,'/iset"'];
        break;
    else
        j = j+1;
    end
end
fclose(fid);
fid = fopen(File,'w+');
for ii = 1:numel(tmp)
   fprintf(fid,'%s',tmp{ii});
   fprintf(fid,'\n');
end
fclose(fid);
clear tmp

end

