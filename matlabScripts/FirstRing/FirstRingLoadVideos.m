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

% vidObj01 = VideoReader(grabLastFileFromCamera('camera01'));
vidObj02 = VideoReader(grabLastFileFromCamera('camera02'));
vidObj03 = VideoReader(grabLastFileFromCamera('camera03'));
vidObj04 = VideoReader(grabLastFileFromCamera('camera04'));
vidObj05 = VideoReader(grabLastFileFromCamera('camera05'));
time = 0:0.001:vidObj02.Duration;

vidObj02.CurrentTime = 32;
vidObj03.CurrentTime = 32;
vidObj04.CurrentTime = 32;
vidObj05.CurrentTime = 32;

%vidObj05.Duration*1/3
figure(1)
while hasFrame(vidObj02)
%     vidFrame01 = rgb2gray(readFrame(vidObj01));
    vidFrame02 = rgb2gray(readFrame(vidObj02));
    vidFrame03 = rgb2gray(readFrame(vidObj03));
    vidFrame04 = rgb2gray(readFrame(vidObj04));
    vidFrame05 = rgb2gray(readFrame(vidObj05));

    frame = [vidFrame02 vidFrame03; vidFrame04 vidFrame05];

    imshow(frame)
    if recordVideo
        writeVideo(v,frame)
    end
    pause(1/vidObj02.FrameRate);
end

if recordVideo
    close(v);
end

%% functions

function fileName = grabLastFileFromCamera(cameraName)
    x = dir(['\\10.19.2.139\Public\' cameraName]);
    fileName = [x(end).folder '\' x(end).name];
end