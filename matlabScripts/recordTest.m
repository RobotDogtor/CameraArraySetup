clear 
clc

%%

URLs = getAllCameraURLs();

AnonFunLibrary

leaderURL = '10.19.2.102';

pause(5)
runMethodOnURLs({leaderURL},startRecording);
pause(1)
runMethodOnURLs({leaderURL},stopRecording);
pause(6)
runSaveMethodOnURLs(URLs);