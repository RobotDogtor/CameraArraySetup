% can be used to combine just a couple videos from a trial to see a
% particular thing
clear
clc
close all

%%
camsToAdd = [54 44];
file = 'Video_29-Jul-2022_20-12-40_BatTrial11';
specialName = 'LandingDynamics';

disp(['compiling video for file: ' file])
resX = 1280;
resY = 1024;

vidObjectList = {};
for i = 1:length(camsToAdd)
    vidObjectList{i} = VideoReader(grabThisFileFromCamera(getCameraName(camsToAdd(i)),file));
    disp(['Successfully loaded file for camera ' num2str(camsToAdd(i))])
end

videoName = [specialName '_' file];

%% Make Video
fileName = ['C:\Users\User\Desktop\outputFiles\special\' videoName '.avi'];
if isfile(fileName)
    delete(fileName)
end

v = VideoWriter(fileName);
open(v);

frame = uint8(zeros(resY,resX*length(camsToAdd)));
emptyFrame = uint8(zeros(resY,resX));
scale = 1;
tic
frameCount = 0;
stillFrames = true;
while(stillFrames)
    frameCount = frameCount+1;
%         if frameCount>1000
%             break;
%         end
    for i = 1:length(vidObjectList)
        %if fail to load frame, be done
        try
            newFrame = rgb2gray(readFrame(vidObjectList{i}));
        catch
            stillFrames = false;
        end
%             %flip 4 or 5 cameras
%             if camNums(i) == 4 || camNums(i) == 5
%                 newFrame = flip(flip(newFrame)')';
%             end
        frame(:,(i-1)*resX+1:resX*i) = newFrame;
    end
    writeVideo(v,frame(1:scale:end,1:scale:end));
end
close(v);
toc

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