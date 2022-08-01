clear
clc
format compact
close all

%% 
% ringNums = [0 1 2 3];
ringNumsToProcess = [2];
ringNumsToCompile = [0 1 2 3 4 5 6 7 8 9];
ringNumsToCompile = [0 1 2 3];

% file = 'Video_25-Jul-2022_13-34-21_40percLight';
% file = 'Video_25-Jul-2022_14-58-03_Godz20percLight';
% file = 'Video_25-Jul-2022_14-35-45_Godz20percLight';


file = 'snakeDrop1';
CompileVideoFromFile(file,[2],[1 2 3]);

file = 'snakeDrop2';
CompileVideoFromFile(file,[1 2 3],[1 2 3]);

file = 'snakeDrop3';
CompileVideoFromFile(file,ringNumsToCompile,ringNumsToCompile);

file = 'snakeDrop4';
CompileVideoFromFile(file,ringNumsToCompile,ringNumsToCompile);

file = 'snakeDrop5';
CompileVideoFromFile(file,ringNumsToCompile,ringNumsToCompile);

% file = 'Video_29-Jul-2022_00-31-48_Svabodaing';
% CompileVideoFromFile(file,ringNumsToCompile,ringNumsToCompile);