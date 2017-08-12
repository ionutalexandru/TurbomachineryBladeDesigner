function [ Thick_max ] = MaxThickness( Thickness_Profile )
%MAXTHICKNESS Summary of this function goes here
%   Input: Thickness_Profile: First row is the x coord while the second,
%   the thickness
%   Output: Maximum Thickness of the Profile and the x-coord
%% Load profile
ProfileFileName = strcat('./ThicknessProfiles/',Thickness_Profile,'.dat');
Thickness = load(ProfileFileName);
%Multiply by the chord 1
[T, I] = max(Thickness(2,:)); % 100%
Thick_max = [Thickness(1,I), T]; % 100%
end

