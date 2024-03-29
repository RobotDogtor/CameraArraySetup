% planarmove ... alignment under assumption of planar motion
%
% [align,cam] = planarmove(in,cam,config)
% in, cam, config ... see the main GOCAL script
%
% align ... structures aligned wit the specified world frame
%
% $Id: planarmove.m,v 1.1 2003/07/03 15:35:55 svoboda Exp $

function [align,cam] = planarmove(in,cam,config)

% fit a plane to the reconstructed points and estimate normal

plane.n = planefit(in.Xe(1:3,:)');

new.n = [0,0,1]'; % align the xy plane horizontally

rotaxis = cross(plane.n,new.n);
rotangle = acos( (plane.n'*new.n)/norm(plane.n)*norm(new.n) );

R = nfi2r(rotaxis,rotangle);
s = 3;
t = [0,0,1]' - s*R*mean(in.Xe(1:3,:)')';

align.simT.s = s;
align.simT.R = R;
align.simT.t = t;

[align.P, align.X]							= align3d(in.Pe,in.Xe,align.simT);	 		
% save aligned data
if 1 % SAVE_STEPHI | SAVE_PGUHA
	[align.Cst,align.Rot] = savecalpar(align.P,config);
end
drawscene(align.X,align.Cst',align.Rot,61,'cloud','Graphical Output Validation: Aligned data, TopView',config.cal.cams2use);

set(gca,'CameraTarget',[0,0,1]);
set(gca,'CameraPosition',[0,0,2]);

figure(61), 
% print -depsc graphevalaligned.eps
eval(['print -depsc ', config.paths.data, 'topview.eps'])

drawscene(align.X,align.Cst',align.Rot,62,'cloud','Graphical Output Validation: Aligned data, SideView',config.cal.cams2use);

set(gca,'CameraTarget',[0,0,0.9]);
set(gca,'CameraPosition',[2,0,0.9]);

figure(62), 
% print -depsc graphevalaligned.eps
eval(['print -depsc ', config.paths.data, 'sideview.eps'])

return


