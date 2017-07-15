function  [Message, x, t] = Register(text)
%REGISTER Summary of this function goes here
%   Detailed explanation goes here
%   This function receives as input the text introduced
%   by user to be inserted as a thickness profile
%   Steps that are followed:
%   1. Check whether input is properly written
%   2. Analyze text and interpreted
%   3. Save

%% Store data
% First, separate into x and t
remain = text;
segments = strings(0);
while (remain~="")
    [token, remain] = strtok(remain,';');
    segments = [segments ; token];
end

% x profile
remain = segments{1};
x = strings(0);
while (remain~="")
   [token, remain] = strtok(remain);
   x = [x, token];
end
x = str2double(x);

% y profile
remain = segments{2};
t = strings(0);
while (remain~="")
   [token, remain] = strtok(remain);
   t = [t, token];
end
t = str2double(t);

Message = ErrorCheckRegister(x,t);
end

