clear 
clc

%%

URLs = getAllCameraURLs();

AnonFunLibrary

leaderURL = '10.19.2.102';

pause(10) % here so that I had time to start the code and then walk up and wave
runMethodOnURLs({leaderURL},startRecording);
pause(2) % recording time
runMethodOnURLs({leaderURL},stopRecording);
pause(20) % delay for saving
% runSaveMethodOnURLs(URLs);