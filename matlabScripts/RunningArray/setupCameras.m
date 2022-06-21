clear
clc

URLs = getAllCameraURLs();

AnonFunLibrary

runMethodOnURLs(URLs,stopRecording);
runMethodOnURLs(URLs,setFrameRate);

for i = 1:length(inputSettingFunctionsFollower)
    runMethodOnURLs(URLs,inputSettingFunctionsFollower{i});
    disp(['set setting ' num2str(i) '/' num2str(length(inputSettingFunctionsFollower))]);
end