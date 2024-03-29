% main function to launch the estimation 
% of the non-linear parameters by using the CalTech
% calibration toolbox and the output from the Svoboda's
% Multicamera self-calibration
%
% How to create the input data:
% 1) Run the MultiCamSelfCam
% 2) Run the MultiCamValidation
%
% $Id: goradf.m,v 2.0 2003/06/19 12:06:00 svoboda Exp $

function selfcalib = goradf(config,par2estimate,INL_TOL)

% assignment of the parameters to estimate
initFOV = par2estimate(1);
center_optim = par2estimate(2);
est_dist = par2estimate(3:6)';

% if problem with desactivated images -> some problems with the estimation in general
desactivated_images = [];

idxcams = config.cal.cams2use;
selfcalib.goradproblem = 0;
					   
for i = idxcams,  
  [X_1,x_1] = preparedata(sprintf(config.files.points4cal,i));
  go_calib_optim_iter
  if any(isnan(param)) | any(err_std > 2*INL_TOL)
	  % when the iteration fails insert null distortion
	  % it is better than nonsense
	  KK = [700 0 320; 0 700 240; 0 0 1];		% void calibration matrix
	  kc(1:4) = [0,0,0,0];
	  selfcalib.goradproblem=1;
      visualize_distortions
  else
	  visualize_distortions	  
  end

  disp(sprintf('***** camera %d **********************************',i))
  %
  outputfile = sprintf(config.files.rad,i);

     fprintf(1,'\nExport of intrinsic calibration data to blue-c configuration file\n');
     % outputfile = input('File basename: ', 's');
     configfile = outputfile;
     disp(['Writing ' configfile]);
     
     fid = fopen(configfile, 'w');
     
     fprintf(fid, 'K11 = %.16f\n', KK(1,1));
     fprintf(fid, 'K12 = %.16f\n', KK(1,2));
     fprintf(fid, 'K13 = %.16f\n', KK(1,3));
     fprintf(fid, 'K21 = %.16f\n', KK(2,1));
     fprintf(fid, 'K22 = %.16f\n', KK(2,2));
     fprintf(fid, 'K23 = %.16f\n', KK(2,3));
     fprintf(fid, 'K31 = %.16f\n', KK(3,1));
     fprintf(fid, 'K32 = %.16f\n', KK(3,2));
     fprintf(fid, 'K33 = %.16f\n\n', KK(3,3));
     
     fprintf(fid, 'kc1 = %.16f\n', kc(1));
     fprintf(fid, 'kc2 = %.16f\n', kc(2));
     fprintf(fid, 'kc3 = %.16f\n', kc(3));
     fprintf(fid, 'kc4 = %.16f\n', kc(4));

     status = fclose(fid);

% disp('Press any key to continue'),  pause

%%%
% clear already estimated parameters
clear fc kc alpha_c cc

end

return
																														     
