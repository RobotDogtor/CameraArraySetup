clear
clc
format compact
pause('on')

%%
AnonFunLibrary


%%
% URLs = getAllCameraURLs();

URLsF = {'10.19.2.103';
        '10.19.2.104';
        '10.19.2.105'};
URLsL = {'10.19.2.102'};

URLs = {'10.19.2.103';
        '10.19.2.104';
        '10.19.2.105';
        '10.19.2.102'};

%%

runMethodOnURLs(URLs,stopRecording);
pause(5)
runMethodOnURLs(URLsL,startRecording);
pause(2)
runMethodOnURLs(URLsL,stopRecording);
pause(4)
runSaveMethodOnURLs(URLs);

