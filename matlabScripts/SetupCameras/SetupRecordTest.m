clear
clc
format compact
pause('on')

%%
[URLs,leaderURL] = getSetupURLs();
AnonFunLibrary

setupCameraAsLeader(leaderURL);
%%

runMethodOnURLs(URLs,setFrameRate);
pause(4)
runMethodOnURLs({leaderURL},startRecording);
pause(2)
runMethodOnURLs({leaderURL},stopRecording);
pause(4)
runSaveMethodOnURLs(URLs);

