clear
clc

%%

URLs = getAllCameraURLs();
numCameras = length(URLs);

num = 1;
vidObj = VideoReader(grabThisFileFromCamera(getCameraName(num)));
frame1 = readFrame(vidObj);
frame2 = rgb2gray(frame1);

vidObj.CurrentTime = 45;

i = 0;
while hasFrame(vidObj)
    i = i + 1;
    frame = im2double(rgb2gray(readFrame(vidObj)));
    other = frame.*(frame>0.9);
    pause(0.001)
    imshow(other)
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

function fileName = grabThisFileFromCamera(cameraName)
    file = 'Video_14-Jul-2022_15-30-37.mp4';
    fileName = ['\\10.19.2.139\Public\' cameraName '\' file]
end