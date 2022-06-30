% Config configuration file for self-calibration experiments
% 
% config = configdata(experiment)
%
% experiment ... string with an experiment name

% $Author: svoboda $
% $Revision: 2.5 $
% $Id: configdata.m,v 2.5 2003/07/15 14:09:08 svoboda Exp $
% $State: Exp $

function config = configdata(experiment)

if nargin<1,
  display('No name of the experiment specified: >>basic<< used as default')
  experiment = 'basic';
end

if strcmp(experiment,'basic')
	error;
elseif strcmp(experiment,'ViRoom20030611')
  config.paths.data     = ['/home/svoboda/viroomData/ViRoom/Calib/20021024Calib/'];
  config.files.basename = 'vr';
  config.paths.img      = config.paths.data;
  config.files.imnames	= 'vr%0.2d_image.*.';
  config.files.idxcams	= [0:3];	% related to the imnames
  config.files.imgext	= 'jpg';
  config.imgs.LEDsize	= 20; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'green'; % color of the laser pointer
  config.cal.DO_GLOBAL_ITER = 0;
  config.cal.GLOBAL_ITER_MAX = 10;
  config.cal.GLOBAL_ITER_THR = 1.5;
  config.cal.NL_UPDATE	= [1,0,1,0,0,0];
  config.cal.INL_TOL	= 7; % if UNDO_RADIAL than it may be relatively small <1 
  config.cal.DO_BA		= 0;
  config.cal.UNDO_RADIAL= 0;
  config.cal.NUM_CAMS_FILL = 1;
elseif strcmp(experiment,'oscar2c1p')
  config.paths.data     = ['/home/svoboda/viroomData/oscar/oscar_2c1p/'];
  config.paths.img      = [config.paths.data,'cam%d/'];
  config.files.imnames	= 'oscar2c1p_';
  config.files.basename	= 'oscar';
  config.files.idxcams	= [1:2];	% related to the imnames
  config.files.idxproj	= [3];		% related to the projectors
  config.cal.cams2use	= [1:3];
  config.files.imgext	= 'jpg';
  config.files.projdata	= [config.paths.data,'files.txt']; % contains the projector data
  config.imgs.LEDsize	= 15; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'green'; % color of the laser pointer
  config.imgs.subpix	= 1/2;	   % scale of the required subpixel accuracy 
  config.imgs.res		= [1392,1024];  
  config.imgs.projres	= [1024,768];	% projector resolution
  config.cal.DO_GLOBAL_ITER = 0;
  config.cal.GLOBAL_ITER_MAX = 10;
  config.cal.GLOBAL_ITER_THR = 0.5;
  config.cal.nonlinpar	= [30,1,1,1,1,1];
  config.cal.NL_UPDATE	= [1,1,1,1,1,1];
  config.cal.INL_TOL	= 2; % if UNDO_RADIAL than it may be relatively small <1 
  config.cal.NUM_CAMS_FILL = 10;
  config.cal.DO_BA		= 0;
  config.cal.UNDO_RADIAL= 0;
  config.cal.MIN_PTS_VAL = 30;
  config.cal.NTUPLES	= 2;
  config.cal.SQUARE_PIX	= 1;
elseif strcmp(experiment,'oscardemo')
  config.paths.data     = ['/home/svoboda/viroomData/oscar/oscardemo2/'];
  config.paths.img      = [config.paths.data,'cam%d/'];
  config.files.imnames	= 'demo3p3c_';
  config.files.basename	= 'oscar';
  config.files.idxcams	= [1:3];	% related to the imnames
  config.files.idxproj	= [4:6];		% related to the projectors
  config.files.imgext	= 'bmp';
  config.files.projdata	= [config.paths.data,'calib_3p3c_p2.txt']; % contains the projector data
  config.imgs.LEDsize	= 35; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'green'; % color of the laser pointer
  config.imgs.subpix	= 1;	   % scale of the required subpixel accuracy 
  config.imgs.res		= [1392,1024];  
  config.imgs.projres	= [1024,768];	% projector resolution
  config.cal.DO_GLOBAL_ITER = 0;
  config.cal.GLOBAL_ITER_MAX = 10;
  config.cal.GLOBAL_ITER_THR = 1;
  config.cal.nonlinpar	= [30,0,1,0,0,0];
  config.cal.NL_UPDATE	= [1,1,1,1,1,1];
  config.cal.INL_TOL	= 3; % if UNDO_RADIAL than it may be relatively small <1 
  config.cal.NUM_CAMS_FILL = 3;
  config.cal.DO_BA		= 1;
  config.cal.START_BA	= 1; % do BA in all intermediate steps
  config.cal.UNDO_RADIAL= 0;
  config.cal.MIN_PTS_VAL = 30;
  config.cal.NTUPLES	= 2;
  config.cal.SQUARE_PIX	= 0; % 0 works surprisingly far better than 1 (special cameras or projectors?)
  config.cal.cams2use	= [1,2,3,4,5,6];
elseif strcmp(experiment,'0801BlueCRZ')
  config.paths.data		= ['/home/svoboda/viroomData/BigBlueC/20030108_BigBlueC/Calib/'];
  config.files.basename = 'atlantic';
  config.paths.img      = [config.paths.data,config.files.basename,'%d/'];
  config.files.imnames	= [config.files.basename,'%d.pvi.*.'];
  config.files.idxcams	= [3:18];	% related to the imnames
  config.files.imgext	= 'jpg';
  config.imgs.LEDsize	= 7; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'green'; % color of the laser pointer
  config.cal.DO_GLOBAL_ITER = 1;
  config.cal.GLOBAL_ITER_MAX = 10;
  config.cal.GLOBAL_ITER_THR = 0.3;
  config.cal.nonlinpar	= [70,1,1,1,0,0];
  config.cal.NL_UPDATE	= [1,1,1,1,0,0];
  config.cal.INL_TOL	= 1; % if UNDO_RADIAL than it may be relatively small <1 
  config.cal.NUM_CAMS_FILL = 10;
  config.cal.DO_BA		= 1;
  config.cal.UNDO_RADIAL= 1;
  config.cal.MIN_PTS_VAL = 200;
  config.cal.NTUPLES	= 3;
  config.imgs.subpix	= 1/5;
  % config.cal.cams2use	= 4; 
elseif strcmp(experiment,'BlueCRZ')
  config.paths.data		= ['/scratch/tomas/'];
  config.files.basename = 'atlantic';
  config.paths.img      = [config.paths.data,config.files.basename,'%d/'];
  config.files.imnames	= [config.files.basename,'%d.pvi.*.'];
  config.files.idxcams	= [3:12,14:18];	% related to the imnames
  config.imgs.LEDsize	= 7; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'green'; % color of the laser pointer
  config.imgs.subpix	= 1/3;
  config.cal.nonlinpar	= [70,0,1,0,0,0];
  config.cal.NL_UPDATE	= [1,1,1,1,1,1];
  config.cal.DO_GLOBAL_ITER = 1;
  config.cal.GLOBAL_ITER_MAX = 10;
  config.cal.GLOBAL_ITER_THR = 0.5;
  config.cal.INL_TOL	= 10; % 
  config.cal.NUM_CAMS_FILL = 10;
  config.cal.DO_BA		= 0;
  config.cal.MIN_PTS_VAL = 30;
  config.cal.UNDO_RADIAL= 0;
  config.cal.NTUPLES	= 3;
  config.cal.SQUARE_PIX	= 1;
  % config.cal.cams2use	= [3:12,14:18];
  % config.cal.cams2use	= [5,6,12];
  % config.cal.cams2use	= [3,4,5,6,9,10,17,18];
elseif strcmp(experiment,'BlueCHoengg')
  config.paths.data		= ['/scratch/WorkingCalib/'];
  config.files.basename = 'arctic';
  config.paths.img      = [config.paths.data,config.files.basename,'%d/'];
  config.files.imnames	= [config.files.basename,'%d.pvi.*.'];
  config.files.idxcams	= [1:16];	% related to the imnames
  config.imgs.LEDsize	= 7; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'green'; % color of the laser pointer
  config.imgs.subpix	= 1/3;
  config.cal.nonlinpar	= [70,0,1,0,0,0];
  config.cal.DO_GLOBAL_ITER = 1;
  config.cal.GLOBAL_ITER_THR = 0.5;
  config.cal.GLOBAL_ITER_MAX = 10;
  config.cal.INL_TOL	= 10; % if UNDO_RADIAL than it may be relatively small <1 
  config.cal.NUM_CAMS_FILL = 10;
  config.cal.DO_BA		= 0;
  config.cal.UNDO_RADIAL= 0; % CalTech (BlueC compatible)
  config.cal.MIN_PTS_VAL = 30;
  config.cal.NTUPLES	= 3;
  % config.cal.cams2use	= [1:11,13:16];		  % if use of some cams only is required
elseif strcmp(experiment,'2410ViRoom')
  config.paths.data		= ['G:/PhDProject/calibration_data/'];
  config.files.basename = 'camera';
  config.files.imgext	= 'jpg';
  config.paths.img      = [config.paths.data,config.files.basename,'%d/'];
  config.files.imnames	= [config.files.basename,'%d_*.'];
  config.files.idxcams	= [0, 1, 2, 3, 4];
  config.imgs.LEDsize	= 15; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'white'; % color of the laser pointer
  config.imgs.subpix	= 1/3;
  config.imgs.projres   = [1024, 1280];
  config.cal.nonlinpar	= [70,0,1,0,0,0];
  config.cal.NL_UPDATE	= [1,1,1,1,1,1];
  config.cal.DO_GLOBAL_ITER = 0;
  config.cal.GLOBAL_ITER_MAX = 10;
  config.cal.GLOBAL_ITER_THR = 1.5;
  config.cal.nonlinpar = [70,0,1,0,0,0];
  config.cal.NL_UPDATE	= [1,0,1,1,0,0];
  config.cal.INL_TOL	= 5;
  config.cal.START_BA	= 0; % do BA in all intermediate steps
  config.cal.DO_BA		= 0;
  config.cal.UNDO_RADIAL= 0;
  config.cal.NUM_CAMS_FILL = 3;
  config.cal.NTUPLES	= 3;
  config.cal.SQUARE_PIX	= 1;
  % config.cal.cams2use = [20,21,30,40];
  config.imgs.subpix = 1/2;
  config.cal.MIN_PTS_VAL = 20;
elseif strcmp(experiment,'Erlangen')
  config.paths.data     = ['/home/svoboda/viroomData/ViRoom/STAR/WorkingCalib/'];
  config.files.basename = 'erlangen';
  config.paths.img      = [config.paths.data,'Images/'];
  config.files.imnames	= 'cal%0.2d_*';
  config.files.idxcams	= [70,71,72,80,81,82];	% related to the imnames
  config.files.imgext	= 'jpg';
  config.imgs.LEDsize	= 1; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'green'; % color of the laser pointer
  config.cal.DO_GLOBAL_ITER = 0;
  config.cal.GLOBAL_ITER_MAX = 10;
  config.cal.GLOBAL_ITER_THR = 1.5;
  config.cal.nonlinpar = [70,0,1,0,0,0];
  config.cal.NL_UPDATE	= [1,0,1,1,0,0];
  config.cal.INL_TOL	= 3;
  config.cal.START_BA	= 1; % do BA in all intermediate steps
  config.cal.DO_BA		= 1;
  config.cal.UNDO_RADIAL= 0;
  config.cal.NUM_CAMS_FILL = 2;
  config.cal.NTUPLES	= 3;
  config.cal.SQUARE_PIX	= 1;
  % config.cal.cams2use = [70,72,82];
  config.imgs.subpix = 1/2;
  config.cal.MIN_PTS_VAL = 20;
elseif strcmp(experiment,'calibration_trajectory_1')
  config.paths.data		= ['G:/PhDProject/svoboda_algorithm_trajectory_1/'];
  config.files.basename = 'camera';
  config.files.imgext	= 'jpg';
  config.paths.img      = [config.paths.data,config.files.basename,'%d/'];
  config.files.imnames	= [config.files.basename,'%d*.'];
  config.files.idxcams	= [0,1,2,3,4,5,6,7,8, 9,10,11,12,13,16,17,18,19];
  config.imgs.LEDsize	= 5; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'grayscale'; % color of the laser pointer
  config.imgs.subpix	= 1/3;

  config.cal.nonlinpar	= [1,1,1,1,1,1];
  config.cal.NL_UPDATE	= [1,1,1,1,1,1];
  config.cal.DO_GLOBAL_ITER = 5;
  config.cal.GLOBAL_ITER_THR = 1;
  config.cal.GLOBAL_ITER_MAX = 1;
  config.cal.INL_TOL	= 5; %if UNDO_RADIAL than it may be relatively small <1 
  config.cal.NUM_CAMS_FILL = 18;
  config.cal.START_BA = 1;
  config.cal.DO_BA		=1;
  config.cal.UNDO_RADIAL= 0; %CalTech (BlueC compatible)
  config.cal.MIN_PTS_VAL = 100;
  config.cal.NTUPLES	= 3;
elseif strcmp(experiment,'calibration_trajectory_2')
  config.paths.data		= ['G:/PhDProject/svoboda_algorithm_trajectory_2/'];
  config.files.basename = 'camera';
  config.files.imgext	= 'jpg';
  config.paths.img      = [config.paths.data,config.files.basename,'%d/'];
  config.files.imnames	= [config.files.basename,'%d*.'];
  config.files.idxcams	= [0,1,2,3,4];
  config.imgs.LEDsize	= 5; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'grayscale'; % color of the laser pointer
  config.imgs.subpix	= 1/3;

  config.cal.nonlinpar	= [1,1,1,1,1,1];
  config.cal.NL_UPDATE	= [1,1,1,1,1,1];
  config.cal.DO_GLOBAL_ITER = 1;
  config.cal.GLOBAL_ITER_THR = 0.1;
  config.cal.GLOBAL_ITER_MAX = 2;
  config.cal.INL_TOL	= 0.5; %if UNDO_RADIAL than it may be relatively small <1 
  config.cal.NUM_CAMS_FILL = 5;
  config.cal.START_BA = 0;
  config.cal.DO_BA		=1;
  config.cal.UNDO_RADIAL= 0; %CalTech (BlueC compatible)
  config.cal.MIN_PTS_VAL = 30;
  config.cal.NTUPLES	= 3;
elseif strcmp(experiment,'calibration_trajectory_2_double')
  config.paths.data		= ['G:/PhDProject/20_cameras/'];
  config.files.basename = 'camera';
  config.files.imgext	= 'jpg';
  config.paths.img      = [config.paths.data,config.files.basename,'%d/'];
  config.files.imnames	= [config.files.basename,'%d*.'];
  config.files.idxcams	= [0,1,2, 3,4,5,6, 7, 8,9];
  config.imgs.LEDsize	= 5; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'grayscale'; % color of the laser pointer
  config.imgs.subpix	= 1/2;

  config.cal.nonlinpar	= [1,0,1,0,0,0];
  config.cal.NL_UPDATE	= [1,0,1,0,0,0];
  config.cal.DO_GLOBAL_ITER = 1;
  config.cal.GLOBAL_ITER_THR = 1;
  config.cal.GLOBAL_ITER_MAX = 1;
  config.cal.INL_TOL	= 1; %if UNDO_RADIAL than it may be relatively small <1 
  config.cal.NUM_CAMS_FILL = 10;
  config.cal.START_BA = 1;
  config.cal.DO_BA		=0;
  config.cal.UNDO_RADIAL= 0; %CalTech (BlueC compatible)
  config.cal.MIN_PTS_VAL = 20;
  config.cal.NTUPLES	= 3;
elseif strcmp(experiment,'calibration_rearranged_camera_position')
  config.paths.data		= ['G:/PhDProject/rearrange_camera_pose/'];
  config.files.basename = 'camera';
  config.files.imgext	= 'jpg';
  config.paths.img      = [config.paths.data,config.files.basename,'%d/'];
  config.files.imnames	= [config.files.basename,'%d*.'];
  config.files.idxcams	= [0,1, 3,4,19];
  config.imgs.LEDsize	= 5; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'grayscale'; % color of the laser pointer
  config.imgs.subpix	= 1/3;

  config.cal.nonlinpar	= [1,1,1,1,1,1];
  config.cal.NL_UPDATE	= [1,1,1,1,1,1];
  config.cal.DO_GLOBAL_ITER = 1;
  config.cal.GLOBAL_ITER_THR = 1;
  config.cal.GLOBAL_ITER_MAX = 1;
  config.cal.INL_TOL	= 5; %if UNDO_RADIAL than it may be relatively small <1 
  config.cal.NUM_CAMS_FILL = 18;
  config.cal.START_BA = 1;
  config.cal.DO_BA		=1;
  config.cal.UNDO_RADIAL= 0; %CalTech (BlueC compatible)
  config.cal.MIN_PTS_VAL = 20;
  config.cal.NTUPLES	= 3;
elseif strcmp(experiment,'Test')
  config.paths.data		= ['C:/Users/18505/Desktop/MultiCamSelfCal/Data/TestData/'];
  config.files.basename = 'arctic';
  config.paths.img      = [config.paths.data,config.files.basename,'%d/'];
  config.files.imnames	= [config.files.basename,'%d.pvi.*.'];
  config.files.idxcams	= [2,4,6,10];
  config.imgs.LEDsize	= 7; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'green'; % color of the laser pointer
  config.imgs.subpix	= 1/3;
  config.cal.nonlinpar	= [1,0,1,0,0,0];
  config.cal.NL_UPDATE	= [1,0,1,0,0,0];
  config.cal.DO_GLOBAL_ITER = 1;
  config.cal.GLOBAL_ITER_THR = 0.5;
  config.cal.GLOBAL_ITER_MAX = 1;
  config.cal.INL_TOL	= 5; % if UNDO_RADIAL than it may be relatively small <1 
  config.cal.NUM_CAMS_FILL = 4;
  config.cal.DO_BA		= 1;
  config.cal.UNDO_RADIAL= 0; % CalTech (BlueC compatible)
  config.cal.MIN_PTS_VAL = 20;
  config.cal.NTUPLES	= 3;
elseif strcmp(experiment,'new_toy')
  config.paths.data		= ['G:/PhDProject/20_cameras/'];
  config.files.basename = 'camera';
  config.files.imgext	= 'jpg';
  config.paths.img      = [config.paths.data,config.files.basename,'%d/'];
  config.files.imnames	= [config.files.basename,'%d.pvi.*.'];
  config.files.idxcams	= [2,4,6,10];
  config.imgs.LEDsize	= 7; % avg diameter of a LED in pixels  
  config.imgs.LEDcolor	= 'green'; % color of the laser pointer
  config.imgs.subpix	= 1/3;
  config.cal.nonlinpar	= [1,0,1,0,0,0];
  config.cal.NL_UPDATE	= [1,0,1,0,0,0];
  config.cal.DO_GLOBAL_ITER = 1;
  config.cal.GLOBAL_ITER_THR = 0.5;
  config.cal.GLOBAL_ITER_MAX = 1;
  config.cal.INL_TOL	= 5; % if UNDO_RADIAL than it may be relatively small <1 
  config.cal.NUM_CAMS_FILL = 4;
  config.cal.DO_BA		= 1;
  config.cal.UNDO_RADIAL= 0; % CalTech (BlueC compatible)
  config.cal.MIN_PTS_VAL = 20;
  config.cal.NTUPLES	= 3;
else
  error('Configdata: wrong identifier of the data set');
end

% camera indexes handling
try config.cal.cams2use; catch config.cal.cams2use = config.files.idxcams; end

% Default initial settings for the estiamtion of the nonlinear distortion
% (1) ... camera view angle
% (2) ... estimate principal point?
% (3:4) ... parameters of the radial distortion
% (5:6) ... parameters of the tangential distortion
try config.cal.nonlinpar; catch config.cal.nonlinpar = [1,1,1,1,1,1]; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adding more and more non-linear paramaters might be tricky
% in case of bad data. You may fall in the trap of overfitting
% You may want to disable this
% update all possible parameters by default
try config.cal.NL_UPDATE; catch config.cal.NL_UPDATE = [1,1,1,1,1,1]; end



% configuration of the for the calibration process
try config.cal.SQUARE_PIX;	    catch,  config.cal.SQUARE_PIX = 1;end	% most of the cameras have square pixels
try config.cal.DO_GLOBAL_ITER;  catch,  config.cal.DO_GLOBAL_ITER = 1; end
try config.cal.GLOBAL_ITER_THR;	catch,	config.cal.GLOBAL_ITER_THR = 1; end
try config.cal.GLOBAL_ITER_MAX;	catch,	config.cal.GLOBAL_ITER_MAX = 10; end
try config.cal.INL_TOL;         catch,  config.cal.INL_TOL = 5; end;
try config.cal.NUM_CAMS_FILL;	catch,	config.cal.NUM_CAMS_FILL = 12; end;
try config.cal.DO_BA;			catch,	config.cal.DO_BA = 0; end;
try config.cal.UNDO_RADIAL;		catch,	config.cal.UNDO_RADIAL = 0; end;
try config.cal.UNDO_HEIKK;		catch,	config.cal.UNDO_HEIKK = 0; end; % only for testing, not a part of standard package
try config.cal.NTUPLES;			catch,  config.cal.NTUPLES	= 3; end;	% size of the camera tuples, 2-5 implemented
try config.cal.MIN_PTS_VAL;		catch,  config.cal.MIN_PTS_VAL = 50; end; % minimal number of correnspondences in the sample

% image extensions
try config.files.imgext;  catch,  config.files.imgext	= 'jpg'; end;

% image resolution
try config.imgs.res; catch, config.imgs.res		  = [1024, 1280];	end;

% scale for the subpixel accuracy
% 1/3 is a good compromise between speed and accuracy
% for high-resolution images or bigger LEDs you may try 1/1 or 1/2
try config.imgs.subpix; catch, config.imgs.subpix = 1/3; end;

% data names
try config.files.Pmats;      catch, config.files.Pmats	    = [config.paths.data,'Pmatrices.dat'];		end;
try config.files.points;	 catch, config.files.points		= [config.paths.data,'points.dat'];		end;
try config.files.IdPoints;	 catch,	config.files.IdPoints	= [config.paths.data,'IdPoints.dat'];		end;
try config.files.Res;		 catch,	config.files.Res		= [config.paths.data,'Res.dat'];		end;
try config.files.IdMat;		 catch, config.files.IdMat		= [config.paths.data,'IdMat.dat'];			end;
try config.files.inidx;		 catch, config.files.inidx		= [config.paths.data,'idxin.dat'];			end;
try config.files.avIM;		 catch, config.files.avIM		= [config.paths.data,'camera%d.average.tiff'];		end;
try config.files.stdIM;		 catch, config.files.stdIM		= [config.paths.data,'camera%d.std.tiff'];		end;
try config.files.CalPar;	 catch, config.files.CalPar		= [config.paths.data,'camera%d.cal'];			end;
try config.files.CalPmat;	 catch, config.files.CalPmat	= [config.paths.data,'camera%d.Pmat.cal'];			end;
try config.files.StCalPar;	 catch,	config.files.StCalPar	= [config.paths.data,config.files.basename,'%d.cal'];	end;
try config.files.rad;		 catch, config.files.rad		= [config.paths.data,config.files.basename,'%d.rad'];	end;
try config.files.heikkrad;	 catch, config.files.heikkrad	= [config.paths.data,config.files.basename,'%d.heikk'];	end;
try config.files.Pst;		 catch,	config.files.Pst		= [config.paths.data,'Pst.dat']; end;
try	config.files.Cst;		 catch,	config.files.Cst		= [config.paths.data,'Cst.dat']; end;
try config.files.points4cal; catch,	config.files.points4cal = [config.paths.data,'cam%d.points4cal.dat']; end;
