clear 
clc

%%

URLs = getAllCameraURLs();

AnonFunLibrary

leaderURL = '10.19.2.101';

% pause(0) % here so that I had time to start the code and then walk up and wave
% runMethodOnURLs({leaderURL},startRecording);
% disp("recording starting");
% pause(20) % recording time
% runMethodOnURLs({leaderURL},stopRecording);
% disp("pausing");
% % pause(30) % delay for saving
% disp("saving");
% % runSaveMethodOnURLs(URLs);
% disp("done saving")


%%

currDateTime = char(datetime('now'));
currDateTime = strrep(currDateTime,' ','_');
currDateTime = strrep(currDateTime,':','-');
%name = ['Video_' currDateTime '_RSedulus_Day6_T8'];
name = ['Video_' currDateTime '_Abhradeep_self_trial1_1000fps'];
runSaveMethodOnRings([0],name);
% runSaveMethodOnRings([0 1 2],name);
% runSaveMethodOnRings([3 4 5],name);
% runSaveMethodOnRings([6 7 8 9],name);

%name = ['Video_' currDateTime 'SvabodaFullRings5to9_T2'];   
% runSaveMethodOnRings([0 1],name);
% runSaveMethodOnRings([2 3],name);
% runSaveMethodOnRings([4],name);
%runSaveMethodOnRings([5],name);
%runSaveMethodOnRings([6 7],name);
%runSaveMethodOnRings([8 9],name);

%   webwrite(['http://10.19.2.152/control/startFilesave'],'format','h264','device','smb','filename',name);