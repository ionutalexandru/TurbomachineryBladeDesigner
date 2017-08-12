function FileName = CreateLogFile(Option)
%CREATELOGFILE Summary of this function goes here
%   Detailed explanation goes here:
%   This function create the log file

format shortg
c = clock();
FileName = strcat('./Log/Log_',Option,'-',num2str(c(1)),'-',num2str(c(2)),'-',num2str(c(3)),'@',num2str(c(4)),'-',num2str(c(5)),'-',round(num2str(c(6))),'.log');
fileID = fopen(FileName,'a+');
text1 = FileName;
text2 = 'This Log File contains all the changes made by the user';
text3 = strcat('Program has been run at: ',num2str(c(4)),':',num2str(c(5)),':',num2str(c(6)));
fprintf(fileID,'%s\r\n%s\r\n%s\r\n\r\n',text1,text2,text3);
fclose(fileID);

end

