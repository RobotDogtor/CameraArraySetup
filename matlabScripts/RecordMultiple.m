clear
clc
format compact
pause('on')

%%
startRecording = @(url) urlread(['http://' url '/control/startRecording']);
stopRecording = @(url) urlread(['http://' url '/control/stopRecording']);
saveToSmb = @(url) webwrite(['http://' url '/control/startFilesave'],'format','h264','device','smb');

setFrameRate = @(url) webwrite(['http://' url '/control/p'],'frameRate','1000');

%%
URLs = getAllCameraURLs();

runMethodOnURLs(URLs,setFrameRate);
pause(0.2)
runMethodOnURLs(URLs,startRecording);
pause(2)
runMethodOnURLs(URLs,stopRecording);
pause(0.2)
runMethodOnURLs(URLs,saveToSmb);


%%
function runMethodOnURLs(URLs,method)
    for i = 1:length(URLs) 
        method(URLs{i}); 
    end
end