clear
clc
%INPUT THE LEADER CAMERA URL
leaderURL = '10.19.2.101';

%get all the camera urls
URLs = getAllCameraURLs();

%set up the anonymous function library
AnonFunLibrary

%%
%just stop the cameras from recording if the are already
runMethodOnURLs(URLs,stopRecording);
%set the frame rate to 1000 fps (Takes a longer time)
runMethodOnURLs(URLs,setFrameRate);
%this enables the text box when recording which shows the frame rate and
%such
runMethodOnURLs(URLs,setOverlayEnable);

%for each of the settings functions, for each follower, run the settings to
%calibrate everything
for i = 1:length(inputSettingFunctionsFollower)
    disp(i)
    runMethodOnURLs(URLs,inputSettingFunctionsFollower{i});
    disp(['set setting ' num2str(i) '/' num2str(length(inputSettingFunctionsFollower))]);
end

%%
runMethodOnURLs(URLs,setDigitalGainTo6Db);
runMethodOnURLs(URLs,setAnalogGainTo0Db);

%TODO: run the function to set up the leader camera
setupCameraAsLeader(leaderURL);