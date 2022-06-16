clear 
clc

%% all URLs

URLs = {'10.19.2.101';
        '10.19.2.102';
        '10.19.2.103';
        '10.19.2.104';
        '10.19.2.105'};
URLs = {'10.19.2.103'};
AnonFunLibrary

%% Send all settings to all cameras

for i = 1:length(inputSettingFunctionsFollower)
    runMethodOnURLs(URLs,inputSettingFunctionsFollower{i});
    disp(['set setting ' num2str(i) '/' num2str(length(inputSettingFunctionsFollower))]);
end