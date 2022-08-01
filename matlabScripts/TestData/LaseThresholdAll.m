clear
clc

%%

URLs = getAllCameraURLs();
numCameras = length(URLs);

cami = 0;
for ringNum = [0 1 2 3]
    for camNum = [1 2 3 4 5]
        cami = cami + 1;
        num = ringNum*10+camNum;
        camName = getCameraName(num);

        disp(['processing points for camera ' camName])
        tic
        vidObj = VideoReader(grabThisFileFromCamera(camName));
        [CameraXpoints, CameraYpoints] = processPointsForVideo(vidObj);
        disp(['done processing for camera ' camName])
        toc 
        
        Cameras(cami).CameraXpoints = CameraXpoints;
        Cameras(cami).CameraYpoints = CameraYpoints;
        Cameras(cami).numPoints = length(CameraXpoints);
    end
end



%%
plot(CameraXpoints,CameraYpoints,'ro')
axis([0 1 0 1])

%%
function [CameraXpoints, CameraYpoints] = processPointsForVideo(vidObj)
    imThreshold = 0.9;
    firstRowOfDisplay = 990;
    CameraXpoints = [];
    CameraYpoints = [];
    while hasFrame(vidObj)
        frame = im2double(rgb2gray(readFrame(vidObj)));
        %1024x1280 - remove numbers at bottom
        frame(firstRowOfDisplay:end,:) = frame(firstRowOfDisplay:end,:)*0;
    
        other = frame.*(frame>imThreshold);
        % average thresholded part - maybe will have to average std dev
        xs = [];
        ys = [];
        for i = 1:1024
            for j = 1:1280
                if(other(i,j)>imThreshold)
                    xs = [xs j];
                    ys = [ys i];
                end
            end
        end
        posX = mean(xs)/1280;
        posY = (1024-mean(ys))/1024; %image loads from top left
    
        CameraXpoints = [CameraXpoints posX];
        CameraYpoints = [CameraYpoints posY];
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

function fileName = grabThisFileFromCamera(cameraName)
    file = 'Video_14-Jul-2022_15-30-37.mp4';
    fileName = ['\\10.19.2.139\Public\' cameraName '\' file]
end