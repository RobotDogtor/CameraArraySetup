clear 
clc
close all
format compact

%% open a video writer to save the output
recordVideo = false;




%% First Camera
URLs = getAllCameraURLs();
numCameras = length(URLs);

recordVideoFromRing(0);
recordVideoFromRing(1);
recordVideoFromRing(2);
recordVideoFromRing(3);
% recordVideoFromRing(4);
% recordVideoFromRing(5);
recordCompiledVideoFromRings([0,1,2,3]);

%%
function cameraName = getCameraName(cameraNumber)
    if cameraNumber<10
        numStr = ['0' num2str(cameraNumber)];
    else
        numStr = num2str(cameraNumber);
    end
    cameraName = ['camera' numStr];
end

function fileName = grabLastFileFromCamera(cameraName)
    x = dir(['\\10.19.2.139\Public\' cameraName]);
    fileName = [x(end).folder '\' x(end).name];
end

function fileName = grabThisFileFromCamera(cameraName)
    file = 'Video_14-Jul-2022_15-14-22.mp4';
    fileName = ['\\10.19.2.139\Public\' cameraName '\' file]
end

function recordVideoFromRing(ringNum)
    oneToFive = [1 2 3 4 5];
    vidObjectList = {};
    for i = 1:5
        num = ringNum*10+i;
        vidObjectList{i} = VideoReader(grabThisFileFromCamera(getCameraName(num)));
    end
    videoName = ['ring' num2str(ringNum)];
    recordATempVideoFromCameras(vidObjectList,videoName);
end

function recordATempVideoFromCameras(vidObjectList,videoName)
    fileName = ['C:\Users\User\Desktop\outputFiles\tempVideos\tempVideo_' videoName '.avi'];
    if isfile(fileName)
        delete(fileName)
    end

    %get smallest frame num
    numFrames = 1000000;
    for i = 1:length(vidObjectList)
        if vidObjectList{i}.NumFrames < numFrames
            numFrames = vidObjectList{i}.NumFrames;
        end
    end

    v = VideoWriter(fileName);
    open(v);
    numCameras = length(vidObjectList);
    resX = 1280;
    resY = 1024;
    frame = uint8(zeros(resY,resX*numCameras));
    scale = 4;
    tic
    for jj = 1:numFrames
        for i = 1:numCameras
            frame(:,(i-1)*resX+1:resX*i) = rgb2gray(readFrame(vidObjectList{i}));
        end
        writeVideo(v,frame(1:scale:end,1:scale:end));
    end
    close(v);
    toc
end

function recordCompiledVideoFromRings(ringNums)
    vidObjectList = {};
    for i = 1:length(ringNums)
        videoName = ['ring' num2str(ringNums(i))];
        fileName = ['C:\Users\User\Desktop\outputFiles\tempVideos\tempVideo_' videoName '.avi'];
        vidObjectList{i} = VideoReader(fileName);
    end

    %get smallest frame num
    numFrames = 1000000;
    for i = 1:length(vidObjectList)
        if vidObjectList{i}.NumFrames < numFrames
            numFrames = vidObjectList{i}.NumFrames;
        end
    end

    currDateTime = char(datetime('now'));
    currDateTime = strrep(currDateTime,' ','_');
    currDateTime = strrep(currDateTime,':','-');
    v = VideoWriter(['C:\Users\User\Desktop\outputFiles\OutputVideo' currDateTime '.avi']);
    open(v);

    tic
    for jj = 1:numFrames
        frame = [];
        for i = 1:length(ringNums)
            frame = [frame; rgb2gray(readFrame(vidObjectList{i}))];
        end
        writeVideo(v,frame);
    end
    close(v);
    toc

end