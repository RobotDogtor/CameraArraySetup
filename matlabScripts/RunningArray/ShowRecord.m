clear
clc
close all

%% open a video writer to save the output
recordVideo = true;

if recordVideo
    currDateTime = char(datetime('now'));
    currDateTime = strrep(currDateTime,' ','_');
    currDateTime = strrep(currDateTime,':','-');
    v = VideoWriter(['C:\Users\User\Desktop\outputFiles\OutputVideo' currDateTime '.avi']);
    open(v);
end

%% play the four ring cameras together
URLs = getAllCameraURLs();

numCameras = length(URLs);
vidObjectList = {};
for i = 1:numCameras
    fileName{i} = grabLastFileFromCamera(['camera' URLs{i}(end-1:end)]);
    vidObjectList{i} = VideoReader(fileName{i});
    vidObjectList{i}.CurrentTime = vidObjectList{i}.Duration*3/4;
end
fileName'
%%

figure(1)
num = 0;
while hasFrame(vidObjectList{1})
    num = num+1;
    frame = [];
    for i = 1:numCameras
        frame = [frame rgb2gray(readFrame(vidObjectList{i}))];
    end
    if mod(num,4) == 0
        half = length(frame(1,:))/2;
        imshow([frame(:,1:half); frame(:,half+1:end)])
        if recordVideo
            writeVideo(v,frame)
        end
        pause(1/vidObjectList{1}.FrameRate);
    end
end

if recordVideo
    close(v);
end

%% functions

function fileName = grabLastFileFromCamera(cameraName)
    x = dir(['\\10.19.2.139\Public\' cameraName]);
    fileName = [x(end).folder '\' x(end).name];
end

