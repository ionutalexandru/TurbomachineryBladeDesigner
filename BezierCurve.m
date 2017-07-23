function [Results ] = BezierCurve(P, n)
%BEZIERCURVE Summary of this function goes here
%   Detailed explanation goes here
%   Input: P matrix - composed by the points
%       n - number of points
%   Output: X Y coordinates

n1 = n - 1;
    for    i=0:1:n1
        sigma(i+1)=factorial(n1)/(factorial(i)*factorial(n1-i));  % for calculating (x!/(y!(x-y)!)) values 
    end
    
l=[];
UB=[];

for u=0:0.001:1
    for d=1:n
        UB(d)=sigma(d)*((1-u)^(n-d))*(u^(d-1));
    end
    l=cat(1,l,UB);                                      %catenation 
end
Results = l*P;
end

