function [ IntersectionP ] = IntersectionPoint(X1, X2, Y1, Y2, m1, m2)
%INTERSECTIONPOINT Summary of this function goes here
%   Detailed explanation goes here:
%   This function is used to obtain the intersection point between two
%   straight line defined by one point and a slope
%   r1 =  m1(X-X1) + Y1
%   r2 = m2(X-X2) + Y2
%   m1(X-X1) + Y1 = m2(X-X2) + Y2 --> Y1 - m1X1 - Y2 + m2X2 = XIn(m2-m1)

XIn = (Y1 - Y2 - m1*X1 + m2*X2)/(m2-m1);
YIn = m1*(XIn - X1) + Y1;
IntersectionP = [XIn YIn];
end

