% EXPeriment NAME
% returns the name of the current experiment
% this name indexes the CONFIGDATA
%
% $Id: expname.m,v 2.3 2003/07/15 14:09:08 svoboda Exp $

function name = expname()

% the name of a calibration fo BlueC must 
% contain the following sub-string 'BigBlue'

% the name for the Hoenggeberg calibration must contain
% the sub-string Hoengg

% the name of the oscar setup must contain
% the string 'oscar'

% name = '0801BlueCRZ';
% name = 'BlueCHoengg';
% name = 'BlueCRZ';
% name = 'ViRoom20030611';
% name = '2410ViRoom';
% name = 'Erlangen';
% name = 'oscar2c1p';
% name = 'oscardemo';
% name = 'calibration_trajectory_1';
% name = 'calibration_trajectory_2';
%  name = 'calibration_trajectory_2_double';
 name = 'ArrayCams';
% name = 'Test';
% name ='calibration_rearranged_camera_position'
% name = 'new_toy'
return

