clear 
clc

%%
URLs = getAllCameraURLs();
AnonFunLibrary


% runMethodOnURLs(URLs,flushRecording);

for i = 1:length(URLs)
    chars = totalFramesPrint(URLs{i});
    disp(['Camera: ' URLs{i} '   ' chars(4:25)])
end