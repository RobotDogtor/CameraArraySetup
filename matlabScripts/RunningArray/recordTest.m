clear 
clc

%%

URLs = getAllCameraURLs();

AnonFunLibrary

leaderURL = '10.19.2.101';

pause(0) % here so that I had time to start the code and then walk up and wave
runMethodOnURLs({leaderURL},startRecording);
disp("recording");
% pause(4) % recording time
% runMethodOnURLs({leaderURL},stopRecording);
disp("pausing");
% pause(30) % delay for saving
disp("saving");
% runSaveMethodOnURLs(URLs);
disp("done saving")


%%

currDateTime = char(datetime('now'));
currDateTime = strrep(currDateTime,' ','_');
currDateTime = strrep(currDateTime,':','-');
name = ['Video_' currDateTime '_Godz20percLight'];
runSaveMethodOnRings([0 1],name);
runSaveMethodOnRings([2 3],name);
runSaveMethodOnRings([4 5],name);
runSaveMethodOnRings([6 7],name);
runSaveMethodOnRings([8 9],name);

