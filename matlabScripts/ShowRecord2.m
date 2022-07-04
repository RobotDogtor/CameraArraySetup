clear 
clc
close all
format compact

%% open a video writer to save the output
recordVideo = false;

if recordVideo
    currDateTime = char(datetime('now'));
    currDateTime = strrep(currDateTime,' ','_');
    currDateTime = strrep(currDateTime,':','-');
    v = VideoWriter(['C:\Users\User\Desktop\outputFiles\OutputVideo' currDateTime '.avi']);
    open(v);
end


%% First Camera
URLs = getAllCameraURLs();
numCameras = length(URLs);

% videoMatrix = loadVideoFromCameraNumber(4);
% 
% for i = 1:length(videoMatrix(1,1,:))
%      imshow([uint8(videoMatrix(:,:,i)) uint8(videoMatrix(:,:,i))])
% end

%%
oneToFive = [1 2 3 4 5];
ringsToUse = [1]; 
longestVideoLength = 0;

arrayVideos = {};
for r = ringsToUse
    ringVideo = zeros();
    ringVideos = {};
    %load all video matrices for the ring
    for n = oneToFive
        videoMatrix = loadVideoFromCameraNumber(n*r);
        if length(videoMatrix(1,1,:))>longestVideoLength
            longestVideoLength = length(videoMatrix(1,1,:));
        end
        ringVideos{n} = videoMatrix;
    end
    %create video
    resX = length(ringVideos{1}(1,:,1));
    resY = length(ringVideos{1}(:,1,1));
    ringVideo = zeros(resY,resX,longestVideoLength);
    for n = oneToFive
        ringVideo(:,resX*(n-1)+1:resX*n,:) = ringVideos{n};
    end

end


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

function videoMatrix = loadAVideo(fileName)
    vidObject = VideoReader(fileName);
    numFrames = vidObject.NumFrames;
    thisFrame = double(rgb2gray(readFrame(vidObject)));
    resX = length(thisFrame(1,:));
    resY = length(thisFrame(:,1));
    videoMatrix = zeros(resY,resX,numFrames);
    videoMatrix(:,:,1) = thisFrame;
    for i = 2:numFrames
        videoMatrix(:,:,i) = double(rgb2gray(readFrame(vidObject)));
    end
end

function videoMatrix = loadVideoFromCameraNumber(num)
    videoMatrix = loadAVideo(grabLastFileFromCamera(getCameraName(num)));
    disp(['done with loading video from camera ' num2str(num)])
end