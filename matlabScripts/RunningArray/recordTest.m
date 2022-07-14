clear 
clc

%%

URLs = getAllCameraURLs();

AnonFunLibrary

leaderURL = '10.19.2.101';

pause(0) % here so that I had time to start the code and then walk up and wave
runMethodOnURLs({leaderURL},startRecording);
disp("recording");
pause(8) % recording time
runMethodOnURLs({leaderURL},stopRecording);
disp("saving");
pause(20) % delay for saving
runSaveMethodOnURLs(URLs);
disp("done saving")


