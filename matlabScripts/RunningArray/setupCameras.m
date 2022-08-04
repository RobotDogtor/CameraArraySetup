clear
clc
%INPUT THE LEADER CAMERA URL
leaderURL = '10.19.2.101';

%get all the camera urls
URLs = getAllCameraURLs();
% URLs = {'10.19.2.102'; '10.19.2.112'; '10.19.2.103'; '10.19.2.113'};

%set up the anonymous function library
AnonFunLibrary

%%
%just stop the cameras from recording if the are already
runMethodOnURLs(URLs,stopRecording);
% %set the frame rate to 1000 fps (Takes a longer time)
% runMethodOnURLs(URLs,setFrameRate);
% %this enables the text box when recording which shows the frame rate and
% %such
% runMethodOnURLs(URLs,setOverlayEnable);

%for each of the settings functions, for each follower, run the settings to
%calibrate everything
for i = 1:length(inputSettingFunctionsFollower)
    disp(i)
    runMethodOnURLs(URLs,inputSettingFunctionsFollower{i});
    disp(['set setting ' num2str(i) '/' num2str(length(inputSettingFunctionsFollower))]);
end

% runMethodOnURLs(URLs,setIOStopRec_Follower);
% runMethodOnURLs(URLs,setIOStartRec_Follower);
% runMethodOnURLs(URLs,setIO1_Follower);
% 
% 
% runMethodOnURLs(URLs,setIO1_Follower);
% runMethodOnURLs(URLs,setIOThresh1_5);
% runMethodOnURLs(URLs,setIO2);

%%
% runMethodOnURLs(URLs,setDigitalGainTo6Db);
% runMethodOnURLs(URLs,setAnalogGainTo0Db);

% runMethodOnURLs(URLs,setFrameRate500);
% runMethodOnURLs(URLs,setRecMaxFrames4000);
% runMethodOnURLs(URLs,setFrameRate1000);
% runMethodOnURLs(URLs,setRecMaxFrames8000);


%% run the function to set up the leader camera
setupCameraAsLeader(leaderURL);