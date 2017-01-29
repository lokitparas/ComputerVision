function [ Dist ] = GetDist( Vec1,Vec2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

ydist = Vec2(2)-Vec1(2);
xdist = Vec2(1)-Vec1(1);
Dist = sqrt(ydist*ydist + xdist*xdist);

end

