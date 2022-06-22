clear 
clc

%%

URLs = getAllCameraURLs();

AnonFunLibrary

leaderURL = '10.19.2.102';

pause(10)
runMethodOnURLs({leaderURL},startRecording);
pause(2)
runMethodOnURLs({leaderURL},stopRecording);
pause(20)
% runSaveMethodOnURLs(URLs);