clear 
clc

%% all URLs

URLsF = {'10.19.2.103';
        '10.19.2.104';
        '10.19.2.105'};
AnonFunLibrary


URLsL = {'10.19.2.102'};

%% Send all settings to all cameras


runMethodOnURLs(URLsL,stopRecording);
runMethodOnURLs(URLsF,stopRecording);

for i = 1:length(inputSettingFunctionsFollower)
    runMethodOnURLs(URLsF,inputSettingFunctionsFollower{i});
    disp(['set setting ' num2str(i) '/' num2str(length(inputSettingFunctionsFollower))]);
end

for i = 1:length(inputSettingFunctionsLeader)
    runMethodOnURLs(URLsL,inputSettingFunctionsLeader{i});
    disp(['set setting ' num2str(i) '/' num2str(length(inputSettingFunctionsLeader))]);
end