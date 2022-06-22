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
%     vidObjectList{i}.CurrentTime = vidObjectList{i}.Duration*3/4;
end
fileName'
%%

figure(1)
num = 0;
while hasFrame(vidObjectList{1})
    num = num+1;
    frame = [];
    for i = 1:numCameras
        thisFrame = rgb2gray(readFrame(vidObjectList{i}));
        frame = [frame thisFrame(1:4:end,1:4:end)];
    end
    if mod(num,4) == 0
        half = length(frame(1,:))/2;
        threeTenths = length(frame(1,:))*3/10;
        oneTenth = length(frame(1,:))*1/10;
%         imshow([frame(:,1:half); frame(:,half+1:end)])
        subframe = [frame(:,1:threeTenths); frame(:,threeTenths+1:2*threeTenths); ...
            frame(:,2*threeTenths+1:3*threeTenths); frame(:,3*threeTenths+1:end) frame(:,1:oneTenth*2)*0];
        imshow(subframe);
        if recordVideo
            writeVideo(v,subframe)
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

