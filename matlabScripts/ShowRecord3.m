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
% file = 'Video_25-Jul-2022_13-34-21_40percLight';
file = 'Video_25-Jul-2022_14-58-03_Godz20percLight';
resX = 1280;
resY = 1024;
for ringNum = ringNums
    recordVideoFromRing(ringNum,file,resX,resY);
end
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
    fileName = ['\\10.19.2.139\Public\' cameraName '\' file '.mp4'];
end

function recordVideoFromRing(ringNum,file,resX,resY)
    oneToFive = [1 2 3 4 5];
    vidObjectList = {};
    successfullyLoaded = [false false false false false];
    for i = oneToFive
        num = ringNum*10+i;
        try
            vidObjectList{i} = VideoReader(grabThisFileFromCamera(getCameraName(num),file));
            disp(['Successfully loaded file for camera ' num2str(num)])
            successfullyLoaded(i) = true;
        catch
            disp(['Failed to load camera ' num2str(num)])
            successfullyLoaded(i) = false;
        end
    end
    videoName = ['ring' num2str(ringNum) '_' file];
    recordATempVideoFromCameras(vidObjectList,successfullyLoaded,videoName,resX,resY);
end

function recordATempVideoFromCameras(vidObjectList,successfullyLoaded,videoName,resX,resY)
    fileName = ['C:\Users\User\Desktop\outputFiles\tempVideos\tempVideo_' videoName '.avi'];
    if isfile(fileName)
        delete(fileName)
    end

    %get smallest frame num
    numFrames = 1000000;
    for i = 1:length(vidObjectList)
        if successfullyLoaded(i)
            if vidObjectList{i}.NumFrames < numFrames
                numFrames = vidObjectList{i}.NumFrames;
            end
        end
    end

    v = VideoWriter(fileName);
    open(v);
    
    frame = uint8(zeros(resY,resX*5));
    emptyFrame = uint8(zeros(resY,resX));
    scale = 4;
    tic
    for jj = 1:numFrames
        for i = 1:length(vidObjectList)
            if successfullyLoaded(i)
                frame(:,(i-1)*resX+1:resX*i) = rgb2gray(readFrame(vidObjectList{i}));
            else
                frame(:,(i-1)*resX+1:resX*i) = emptyFrame;
            end
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