clear
clc

%%

vidObj01 = VideoReader(grabLastFileFromCamera('camera01'));
vidObj02 = VideoReader(grabLastFileFromCamera('camera02'));
vidObj03 = VideoReader(grabLastFileFromCamera('camera03'));
vidObj04 = VideoReader(grabLastFileFromCamera('camera04'));
vidObj05 = VideoReader(grabLastFileFromCamera('camera05'));
time = 0:0.001:vidObj01.Duration;

figure(1)
while hasFrame(vidObj01)
    vidFrame01 = rgb2gray(readFrame(vidObj01));
    vidFrame02 = rgb2gray(readFrame(vidObj02));
    vidFrame03 = rgb2gray(readFrame(vidObj03));
    vidFrame04 = rgb2gray(readFrame(vidObj04));
    vidFrame05 = rgb2gray(readFrame(vidObj05));

    frame = [vidFrame01 vidFrame02; vidFrame03 vidFrame04; vidFrame05 vidFrame05*0];

    imshow(frame)
    pause(1/vidObj01.FrameRate);
end


%%

function fileName = grabLastFileFromCamera(cameraName)
    x = dir(['\\10.19.2.139\Public\' cameraName]);
    fileName = [x(end).folder '\' x(end).name];
end