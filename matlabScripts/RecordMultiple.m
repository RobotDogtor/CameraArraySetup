clear
clc
format compact
pause('on')

%%

AnonFunLibrary


%%
URLs = getAllCameraURLs();

runMethodOnURLs(URLs,setFrameRate);
pause(0.2)
runMethodOnURLs(URLs,startRecording);
pause(2)
runMethodOnURLs(URLs,stopRecording);
pause(0.2)
runSaveMethodOnURLs(URLs);

