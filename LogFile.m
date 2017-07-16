function LogFile(FileName, Text)
%LOGFILE Summary of this function goes here
%   Detailed explanation goes here:
%   It adds information to the log file

fileID = fopen(FileName,'a+');
fprintf(fileID,'%s\r\n\r\n',Text);
fclose(fileID);
end

