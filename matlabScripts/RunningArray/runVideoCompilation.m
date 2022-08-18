clear
clc
format compact
close all

%% 
% ringNums = [0 1 2 3];
ringNumsToProcess = [2];
%ringNumsToCompile = [0 1 2 3 4 5 6 7 8 9];
% ringNumsToCompile = [0 1];

% file = 'Video_25-Jul-2022_13-34-21_40percLight';
% file = 'Video_25-Jul-2022_14-58-03_Godz20percLight';
% file = 'Video_25-Jul-2022_14-35-45_Godz20percLight';
% file = 'Video_02-Aug-2022_19-07-22_SvobodaRing1andn2';

clear
clc
close all
ringNumsToCompile = [0 1 2 3 4 5 6 7 8 9];
file = 'Video_09-Aug-2022_13-53-32_BatFlapping2';
CompileVideoFromFile(file,ringNumsToCompile,ringNumsToCompile);

clear  
clc
close all
ringNumsToCompile = [0 1 2 3 4 5 6 7 8 9];
file = 'Video_09-Aug-2022_14-08-09_BatFlapping3';
CompileVideoFromFile(file,ringNumsToCompile,ringNumsToCompile);
% 
% clear
% clc
% close all
% ringNumsToCompile = [0 1 2 3 4 5 6 7 8 9];
% file = 'Video_08-Aug-2022_18-53-34_RSedulus_Day5_T2';
% CompileVideoFromFile(file,ringNumsToCompile,ringNumsToCompile);
% 
% clear
% clc
% close all
% ringNumsToCompile = [0 1 2 3 4 5 6 7 8 9];
% file = 'Video_08-Aug-2022_19-32-45_RSedulus_Day5_T8';
% CompileVideoFromFile(file,ringNumsToCompile,ringNumsToCompile);


