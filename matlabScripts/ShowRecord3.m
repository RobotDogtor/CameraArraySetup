clear 
clc
close all
format compact

%Script that will load the common name of a file for a trial from all
%cameras and compile it into a single video. To manage matlab's resources,
%it will load each ring at a time so it only has 5 videoReader's at a time,
%then load all the compiled videos together for each ring. 

%It tries to read every camera, and if a camera fails it replaces the video
%it doesn't find with a black screen.

%Note: if the camera is a 4 or 5 it flips the video vertically to be in
%line with the other cams





%% First Camera
URLs = getAllCameraURLs();
numCameras = length(URLs);
ringNums = [0 1 2 3 4 5 6 7 8 9];
file = 'Video_23-Jul-2022_18-35-39';
% for ringNum = ringNums
%     try
%         recordVideoFromRing(ringNum,file);
%     catch
%         disp(['ring ' num2str(ringNum) ' has an error and did not save right']);
%     end
% end
recordCompiledVideoFromRings([0,1,2,3,4,5,6,7,8, 9],file);

%%
function cameraName = getCameraName(cameraNumber)
    if cameraNumber<10
        numStr = ['0' num2str(cameraNumber)];
    else
        numStr = num2str(cameraNumber);
    end
    cameraName = ['camera' numStr];
end

function fileName = grabThisFileFromCamera(cameraName,file)
    fileName = ['\\10.19.2.139\Public\' cameraName '\' file '.mp4']
end

function recordVideoFromRing(ringNum,file)
    oneToFive = [1 2 3 4 5];
    vidObjectList = {};
    successfullyLoaded = [false false false false false];
    problemCams = [92 93 95 31];
    for i = oneToFive
        num = ringNum*10+i;
        if sum(num == problemCams)>0
            continue;
        end
        count = count+1;
        vidObjectList{count} = VideoReader(grabThisFileFromCamera(getCameraName(num),file));
    end
    videoName = ['ring' num2str(ringNum) '_' file];
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
    numEmptyCams = 5 - numCameras;
    resX = 1280;
    resY = 1024;
    frame = uint8(zeros(resY,resX*5));
    emptyFrame = uint8(zeros(resY,resX));
    scale = 4;
    tic
    for jj = 1:numFrames
        for i = 1:numCameras
            frame(:,(i-1)*resX+1:resX*i) = rgb2gray(readFrame(vidObjectList{i}));
        end
        for i = numCameras+1:5
            frame(:,(i-1)*resX+1:resX*i) = emptyFrame;
        end
        writeVideo(v,frame(1:scale:end,1:scale:end));
    end
    close(v);
    toc
end

function recordCompiledVideoFromRings(ringNums,file)
    vidObjectList = {};
    for i = 1:length(ringNums)
        videoName = ['ring' num2str(ringNums(i))  '_' file];
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
    v = VideoWriter(['C:\Users\User\Desktop\outputFiles\OutputVideo' currDateTime '_' file '.avi']);
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