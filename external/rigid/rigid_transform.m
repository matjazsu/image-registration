function [T] = rigid_transform(t, r)
%RIGID_TRANSFORM rigid_transform computes the rigid 
% transformation matrix T from translation and rotation parameters
% parameters: [tx, ty, tz], [rx, ry, rz]
% tx, ty, tz: translations in mm
% rx, ry, rz: rotations in degrees

    % calculate radians
    r = r*pi/180;

    T=[cos(r(2))*cos(r(3)), cos(r(3))*sin(r(1))*sin(r(2))-cos(r(1))*sin(r(3)), cos(r(1))*cos(r(3))*sin(r(2))+sin(r(1))*sin(r(3)) t(1);
       cos(r(2))*sin(r(3)), cos(r(1))*cos(r(3))+sin(r(1))*sin(r(2))*sin(r(3)), -cos(r(3))*sin(r(1))+cos(r(1))*sin(r(2))*sin(r(3)) t(2);
       -sin(r(2)), cos(r(2))*sin(r(1)), cos(r(1))*cos(r(2)), t(3);
       0 0 0 1];
end

