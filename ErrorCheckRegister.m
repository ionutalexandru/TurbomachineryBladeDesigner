function Message = ErrorCheckRegister(x, t)
%ERRORCHECKREGISTER Summary of this function goes here
%   Detailed explanation goes here
%   1. Check dimensions - they must coincide
%   2. Check limits
%   And delivers message error if necessary

[~, n1] = size(x);
[~, n2] = size(t);

Message = "";

if n1>n2
    Message1 = ['There are missing ',num2str(n1-n2), ' coordinates of t/l'];
    Message = [Message; Message1];
elseif n2>n1
    Message1 =['There are missing ',num2str(n2-n1), ' coordinates of x/l'];
    Message = [Message; Message1];
else
    Message = Message;
end

if x(1) ~= 0
   Message1 = 'Please, introduce as first coordinate of x/l 0';
   Message = [Message; Message1];

elseif t(1) ~=0
    Message1 = 'Please, introduce as first coordinate of t/l 0';
    Message = [Message; Message1];
else
    Message = Message;
end

if x(n1) ~= 100
   Message1 = 'Please, introduce as last coordinate of x/l 100';
   Message = [Message; Message1];
elseif t(n2) ~=0
    Message1 = 'Please, introduce as last coordinate of t/l 0';
    Message = [Message; Message1];
else
    Message = Message;
end

position = find(x>100);
if ~isempty(position)
    Message1 = ['Position number(s) ',num2str(position), ' is(are) greater than 100'];
    Message = [Message; Message1];
end

position = find(x<0);
if ~isempty(position)
    Message1 = ['Position number(s) ',num2str(position), ' is(are) smaller than 100'];
    Message = [Message; Message1];
end

position = find(t>100);
if ~isempty(position)
    Message1 = ['Position number(s) ',num2str(position), ' is(are) greater than 100'];
    Message = [Message; Message1];
end

position = find(t<0);
if ~isempty(position)
    Message1 = ['Position number(s) ',num2str(position), ' is(are) smaller than 0'];
    Message = [Message; Message1];
end

end

