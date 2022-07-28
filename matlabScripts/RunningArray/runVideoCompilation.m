clear
clc
format compact
close all

%% 
% ringNums = [0 1 2 3];
ringNums = [0 1 2 3 4 5 6 7 8 9];

% file = 'Video_25-Jul-2022_13-34-21_40percLight';
file = 'Video_25-Jul-2022_14-58-03_Godz20percLight';
% file = 'Video_25-Jul-2022_14-35-45_Godz20percLight';

CompileVideoFromFile(file,ringNums);
