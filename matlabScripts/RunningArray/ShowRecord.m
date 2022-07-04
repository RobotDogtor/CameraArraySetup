% clear
% clc
% close all

%% open a video writer to save the output
recordVideo = true;

if recordVideo
    currDateTime = char(datetime('now'));
    currDateTime = strrep(currDateTime,' ','_');
    currDateTime = strrep(currDateTime,':','-');
    v = VideoWriter(['C:\Users\User\Desktop\outputFiles\OutputVideo' currDateTime '.avi']);
    open(v);
end

%% load all the videos
URLs = getAllCameraURLs();

numCameras = length(URLs);
vidObjectList = {};
for i = 1:numCameras
    disp(i)
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
        %flip twice if 4 or 5
        if mod(i,5) == 4 || mod(i,5) == 0
            thisFrame = flip(thisFrame);
        end
        frame = [frame thisFrame(1:4:end,1:4:end)];
    end
    emptyFrame = thisFrame*0;
    for i = numCameras+1:50
        frame = [frame emptyFrame(1:4:end,1:4:end)];
    end
    if mod(num,5) == 0
        half = length(frame(1,:))/2;
        threeTenths = length(frame(1,:))*3/10;
        oneTenth = length(frame(1,:))*1/10;
        oneFifth = length(frame(1,:))*1/5;
%         imshow([frame(:,1:half); frame(:,half+1:end)])
%         subframe = [frame(:,1:threeTenths); frame(:,threeTenths+1:2*threeTenths); ...
%             frame(:,2*threeTenths+1:3*threeTenths); frame(:,3*threeTenths+1:end) frame(:,1:oneTenth*2)*0];
        subframe = [frame(:,1:oneTenth); frame(:,oneTenth+1:2*oneTenth); ...
            frame(:,2*oneTenth+1:3*oneTenth); frame(:,3*oneTenth+1:4*oneTenth); frame(:,4*oneTenth+1:5*oneTenth); ...
            frame(:,5*oneTenth+1:6*oneTenth); frame(:,6*oneTenth+1:7*oneTenth); frame(:,7*oneTenth+1:8*oneTenth); ...
            frame(:,8*oneTenth+1:9*oneTenth); frame(:,10*oneTenth+1:10*oneTenth)];
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

