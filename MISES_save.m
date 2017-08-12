function  [Var, error] = MISES_save( Text )
%MISES_SAVE Summary of this function goes here
%   Detailed explanation goes here
%   It receives as input the text introduced by user
%   It is analysed if it is written properly

i = 1;
while (Text~="")
    [token, Text] = strtok(Text,';');
    Var{i} = token;
    i = i + 1;
end

    if i==6
        error = 0;
    else
        error = 1;
    end
end

