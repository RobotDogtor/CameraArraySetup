% The main script. Performes the self calibration
% The point coordinates are expected to be known
% see the directory FindingPoints
%
% $Author: svoboda $
% $Revision: 2.3 $
% $Id: gocal.m,v 2.3 2003/07/09 14:42:38 svoboda Exp $
% $State: Exp $

clear all
clc
close all

% add necessary paths
addpath ../CommonCfgAndIO
addpath ../RadialDistortions
addpath ./CoreFunctions
addpath ./OutputFunctions
addpath ./BlueCLocal
addpath ./LocalAlignments
% get the configuration						
config = configdata(expname);

%%%
% how many cameras to be filled
% if 0 then only points visible in all cameras will be used for selfcal
% the higher, the more points -> better against Gaussian noise
% however the higher probability of wrong filling
% Then the iterative search for outliers takes accordingly longer
% However, typically no more than 5-7 iterations are needed
% this number should correspond to the total number of the cameras
NUM_CAMS_FILL  = config.cal.NUM_CAMS_FILL;	
%%%
% tolerance for inliers. The higher uncorrected radial distortion
% the higher value. For BlueC cameras set to 2 for the ViRoom
% plastic cams, set to 4 (see FINDINL)
INL_TOL = config.cal.INL_TOL;			
%%%
% Use Bundle Adjustment to refine the final (after removing outliers) results
% It is often not needed at all
DO_BA = config.cal.DO_BA;				
						
UNDO_RADIAL = config.cal.UNDO_RADIAL;		% undo radial distortion, parameters are expected to be available
SAVE_STEPHI = 1;		% save calibration parameters in Stephi's Carve/BlueC compatible form
SAVE_PGUHA	= 1;		% save calib pars in Prithwijit's compatible form
USED_MULTIPROC = 0;		% was the multipropcessing used?
						% if yes then multiple IdMat.dat and points.dat have to be loaded
						% setting to 1 it forces to read the multiprocessor data against the 
						% monoprocessor see the IM2POINTS, IM2PMULTIPROC.PL
						
%%%
% Data structures
% lin.* corrected values which obey linear model    
% in.* inliers, detected by a chain application of Ransac

if findstr(expname,'oscar')
  % add a projector idx to the cameras
  % they are handled the same
  config.files.cams2use = [config.files.idxcams,config.files.idxproj];
end

selfcal.par2estimate = config.cal.nonlinpar;
selfcal.iterate = 1;
selfcal.count	= 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main global cycle begins
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while selfcal.iterate & selfcal.count < config.cal.GLOBAL_ITER_MAX,    % global minimization process
  % read the input data
  loaded = loaddata(config);
  linear = loaded;		% initalize the linear structure             

  CAMS = size(config.cal.cams2use,2);                      
  FRAMES = size(loaded.IdMat,2)  

  if CAMS <1 | FRAMES < 20
	error('gocal: Not enough cameras or images -> Problem in loading data?')
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% correct the required amount of cameras to be filled
  %
  %   keep the frames where the point is observed by at least three cameras
  %
  %   try the frames where the point is observed by all cameras, in this
  %   case, it should be 5
  %   
  %   in the latest case, we use points that are able to be seen by 5
  %   points
  %   take all points as cnsideration
  if CAMS-NUM_CAMS_FILL < 3
	NUM_CAMS_FILL = CAMS-3;
  end
  
  config.cal.pp = reshape([loaded.Res./2,zeros(size(loaded.Res(:,1)))]',CAMS*3,1);
  config.cal.pp = [loaded.Res./2,zeros(size(loaded.Res(:,1)))];
  
  config.cal.pp
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % See the README how to compute data
  % for undoing of the radial distortion
  if UNDO_RADIAL
	for i=1:CAMS,
	  [K,kc] = readradfile(sprintf(config.files.rad,config.cal.cams2use(i)));
      display(K)
	  xn	   = undoradial(loaded.Ws(i*3-2:i*3,:),K,[kc,0]);
	  linear.Ws(i*3-2:i*3,:) = xn;
	end
	linear.Ws = linear.Ws - repmat(reshape(config.cal.pp',CAMS*3,1), 1, FRAMES); 
  elseif config.cal.UNDO_HEIKK,
	for i=1:CAMS,
	  heikkpar = load(sprintf(config.files.heikkrad,config.cal.cams2use(i)),'-ASCII');
	  xn = undoheikk(heikkpar(1:4),heikkpar(5:end),loaded.Ws(i*3-2:i*3-1,:)');
	  linear.Ws(i*3-2:i*3-1,:) = xn';
	end
	linear.Ws = linear.Ws - repmat(reshape(config.cal.pp',CAMS*3,1), 1, FRAMES);
  else
	linear.Ws = loaded.Ws - repmat(reshape(config.cal.pp',CAMS*3,1), 1, FRAMES);  
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Detection of outliers
  % RANSAC is pairwise applied
  addpath ./Ransac;
  disp('RANSAC validation step running ...');

  inliers.IdMat = findinl(linear.Ws,linear.IdMat,INL_TOL); % find the inlier map
     %inliers are calculated

  %linear.IdMat binary show that wheter the point is detected in the frame 

  addpath ./MartinecPajdla;
  setpaths;		% set paths for M&P algorithms

  % remove zero-columns or just 1 point columns
  % create packed represenatation
  % it is still a bit tricky, the number of the minimum number of cameras
  % are specified here, may be some automatic method would be useful
  packed.idx	  = find(sum(inliers.IdMat)>=size(inliers.IdMat,1)-NUM_CAMS_FILL);  %num_cams_fill = 5
                   %find(sum)
  
  packed.IdMat  = inliers.IdMat(:,packed.idx);
  packed.Ws	  = linear.Ws(:,packed.idx);

  if size(packed.Ws,2)<20
	error(sprintf('Only %d points survived RANSAC validation and packing: probably not enough points for reliable selfcalibration',size(packed.Ws,2)));
  end
    %check if the number of inliers is enough
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% fill cam(i) structures
  for i=1:CAMS,
	cam(i).camId  = config.cal.cams2use(i);   % camera ID
	cam(i).idlin  = find(linear.IdMat(i,:)); % loaded structure
	cam(i).idin	  = find(inliers.IdMat(i,:));	% survived initial pairwise validation
	cam(i).xdist  = loaded.Ws(3*i-2:3*i,cam(i).idlin);  % original distorted coordinates
	cam(i).xgt	  = linear.Ws(3*i-2:3*i,cam(i).idlin); 
	cam(i).xgtin  = linear.Ws(3*i-2:3*i,cam(i).idin); 
	% convert the ground truth coordinates by using the known principal
	% point (what is the camera's principle points)
	cam(i).xgt    = cam(i).xgt + repmat(config.cal.pp(i,:)', 1, size(cam(i).xgt,2));
	cam(i).xgtin  = cam(i).xgtin + repmat(config.cal.pp(i,:)', 1, size(cam(i).xgtin,2));
  end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% options for the Martinec-Pajdla filling procedure
  options.verbose = 1;
  try options.no_BA = ~config.cal.START_BA; catch options.no_BA = 1; end % 1 0
  options.iter = 1;
  options.detection_accuracy = 0.5;
  options.consistent_number  = 9;
  options.consistent_number_min = 6;
  options.samples = 1000; %1000; %10000;
  options.sequence = 0;
  options.create_nullspace.trial_coef = 10; %20;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% start of the *compute and remove outliers cycle*
  outliers = 1;
  loop_counter = 0;
  inliers.idx = packed.idx;
  
  while  loop_counter <2
    disp(sprintf('%d number of outliers', outliers));
	disp(sprintf('%d points/frames have survived validations so far',size(inliers.idx,2))) 
    
    %inlier.idx: record the index of frame where the point is observed by
    %at least three camera
	disp('Filling of missing points is running ...')
	[P,X, u1,u2, info] = fill_mm_bundle(linear.Ws(:,inliers.idx),config.cal.pp(:,1:2)',options);

	Rmat = P*X;
	Lambda = Rmat(3:3:end,:);

	[Pe,Xe,Ce,Re,K] = euclidize(Rmat,Lambda,P,X,config);    
	disp('************************************************************')

	% compute reprojection errors
	cam = reprerror(cam,Pe,Xe,FRAMES,inliers);

	% detect outliers in cameras
	[outliers,inliers] = findoutl(cam,inliers,INL_TOL,NUM_CAMS_FILL);
	
	[[cam(:).std2Derr]',[cam(:).mean2Derr]', sum(inliers.IdMat')']
	disp('***************************************************************')
    loop_counter = loop_counter + 1;
  end
  %%% end of the cycle
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% Do the final refinement through the BA if required
  if DO_BA
	disp('**************************************************************')
	disp('Refinement by using Bundle Adjustment')
	options.no_BA = 0; 
	[P,X, u1,u2, info] = fill_mm_bundle(linear.Ws(:,inliers.idx),config.cal.pp(:,1:2)',options);
	[in.Pe,in.Xe,in.Ce,in.Re] = euclidize(Rmat,Lambda,P,X,config);
	cam = reprerror(cam,in.Pe,in.Xe,FRAMES,inliers);
	% [outliers,inliers] = findoutl(cam,inliers,INL_TOL,NUM_CAMS_FILL);
  else
	in.Pe = Pe; in.Xe = Xe; in.Ce = Ce; in.Re = Re;
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  if 1
	% plot reconstructed cameras and points
	drawscene(Xe,Ce,Re,3,'cloud','reconstructed points/camera setup');
	drawscene(in.Xe,in.Ce,in.Re,4,'cloud','reconstructed points/camera setup only inliers are used',config.cal.cams2use);
	
	% plot measured and reprojected 2D points
	for i=1:CAMS
	  in.xe		= in.Pe(((3*i)-2):(3*i),:)*in.Xe;
	  cam(i).inxe	= in.xe./repmat(in.xe(3,:),3,1);
	  figure(i+10)
	  clf	
	  plot(cam(i).xdist(1,:),cam(i).xdist(2,:),'go');
	  hold on, grid on
	  plot(cam(i).xgt(1,:),cam(i).xgt(2,:),'ro');
	  plot(cam(i).xgtin(1,:),cam(i).xgtin(2,:),'bo');
	  % plot(cam(i).xe(1,:),cam(i).xe(2,:),'r+')
	  plot(cam(i).inxe(1,:),cam(i).inxe(2,:),'k+','MarkerSize',7)
	  %plot(xe(1,:),xe(2,:),'r+','linewidth',3,'MarkerSize',10)
	  title(sprintf('measured, o, vs reprojected, +,  2D points (camera: %d)',config.cal.cams2use(i)));
	  for j=1:size(cam(i).visandrec,2); % plot the reprojection errors
		line([cam(i).xgt(1,cam(i).visandrec(j)),cam(i).inxe(1,cam(i).recandvis(j))],[cam(i).xgt(2,cam(i).visandrec(j)),cam(i).inxe(2,cam(i).recandvis(j))],'Color','g');
	  end
	  % draw the image boarder
	  line([0 0 0 2*config.cal.pp(i,1) 2*config.cal.pp(i,1) 2*config.cal.pp(i,1) 2*config.cal.pp(i,1) 0],[0 2*config.cal.pp(i,2) 2*config.cal.pp(i,2) 2*config.cal.pp(i,2) 2*config.cal.pp(i,2) 0 0 0],'Color','k','LineWidth',2,'LineStyle','--')
	  axis('equal')
	  drawnow
	  eval(['print -depsc ', config.paths.data, sprintf('%s%d.reprojection.eps',config.files.basename,cam(i).camId)])
	end
  end

  %%%
  % SAVE camera matrices
  P = in.Pe;
  save(config.files.Pmats,'P','-ASCII');

  % save normal data
  if SAVE_STEPHI | SAVE_PGUHA
	 [in.Cst,in.Rot] = savecalpar(in.Pe,config);
  end	

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % local routines for the BlueC installations
  % The main functionality of these functions that
  % they align the coordinate frame from the selfcalibration
  % with the pre-defined world frame
  % it is assumed the necessary informations are avialable
  if findstr('BlueCRZ',expname)
	  [align,cam] = bluecrz(in,cam,config);
  end
  if findstr('Hoengg',expname)
	  [align,cam] = bluechoengg(in,cam,config);
  end
  if findstr('Erlangen',expname)
	  % [align,cam] = erlangen(in,cam,config);
	  [align,cam] = planarmove(in,cam,config);
  end
  
  % [align,cam] = planarmove(in,cam,config);
  % [align,cam] = planarcams(in,cam,config,[1:6]);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Evaluate reprojection error
  %%%
  cam = evalreprerror(cam,config);

  %%%%
  % Save the 2D-3D correpondences for further processing
  for i=1:CAMS,
	xe = cam(i).xdist(1:3,cam(i).visandrec);	% save the original distorted coordinates
 	% save the reconstructed points (aligned if available)
	% try Xe = align.X(1:4,cam(i).recandvis); catch, Xe = in.Xe(1:4,cam(i).recandvis); end;
	Xe = in.Xe(1:4,cam(i).recandvis);
	corresp = [Xe',xe'];
	save(sprintf(config.files.points4cal,config.cal.cams2use(i)),'corresp','-ASCII');
  end

%%%
% TO-DO:
% - find a suitable end condition for the global iteration.
%   This threshold may very depend on local conditions
%
% - how to check meaningful number of iterations
%   typically only few iterations are needed
%
% - The precision of the non-linear estimation should be somehow taken into account

  selfcal.count = selfcal.count+1;

  if max([cam.mean2Derr])>config.cal.GLOBAL_ITER_THR & config.cal.DO_GLOBAL_ITER & selfcal.count < config.cal.GLOBAL_ITER_MAX 
	 % if the maximal reprojection error is still bigger
	 % than acceptable estimate radial distortion and
	 % iterate further
	 cd ../CalTechCal
	 selfcalib = goradf(config,selfcal.par2estimate,INL_TOL);
	 cd ../MultiCamSelfCal
	 selfcal.iterate = 1;
	 UNDO_RADIAL = 1;
	 if ~selfcalib.goradproblem;
		% if all non-linear parameters estimated reliable
		% we can reduce the tolerance threshold
		INL_TOL = max([(2/3)*INL_TOL,config.cal.GLOBAL_ITER_THR]);
		% add the second radial distortion parameter
		if config.cal.NL_UPDATE(4), selfcal.par2estimate(4) = 1; end
		% estimate also the principal point
		if selfcal.count > 1 & config.cal.NL_UPDATE(2), selfcal.par2estimate(2) = 1; end
		% estimate also the tangential distortion
		if selfcal.count > 3 & all(config.cal.NL_UPDATE(5:6)), selfcal.par2estimate(5:6) = 1; end
	end
  else
	% ends the iteration
	% the last computed parameters will be taken as valid
	selfcal.iterate = 0;
  end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of the main global cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
 
  
  

