clear
clc
close all

%% play the four ring cameras together
[URLs,leaderNum] = getSetupURLs();

numCameras = length(URLs);
vidObjectList = {};
for i = 1:numCameras
    vidObjectList{i} = VideoReader(grabLastFileFromCamera(['camera' URLs{i}(end-1:end)]));
    vidObjectList{i}.CurrentTime = vidObjectList{i}.Duration*3/4;
end

figure(1)
while hasFrame(vidObjectList{1})
    
    frame = [];
    for i = 1:numCameras
        frame = [frame rgb2gray(readFrame(vidObjectList{i}))];
    end

    imshow(frame)
    pause(1/vidObjectList{1}.FrameRate);
end

%% functions

function fileName = grabLastFileFromCamera(cameraName)
    x = dir(['\\10.19.2.139\Public\' cameraName]);
    fileName = [x(end).folder '\' x(end).name];
end