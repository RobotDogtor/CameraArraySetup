clear
clc

%% Check Serial Numbers
URLs = getSetupURLs();

for i = 1:length(URLs)
    cameraIP = URLs{i};
    result = urlread(['http://' cameraIP '/control/p/cameraSerial']);
    result(5:29)
end

%% Configure as followers
AnonFunLibrary

runMethodOnURLs(URLs,stopRecording);
runMethodOnURLs(URLs,setFrameRate);

for i = 1:length(inputSettingFunctionsFollower)
    runMethodOnURLs(URLs,inputSettingFunctionsFollower{i});
    disp(['set setting ' num2str(i) '/' num2str(length(inputSettingFunctionsFollower))]);
end
