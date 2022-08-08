%%

function CompileVideoFromFile(file,ringNumsToProcess,ringNumsToCompile)
    disp(['compiling video for file: ' file])
    resX = 1280;
    resY = 1024;
    for ringNum = ringNumsToProcess
        recordVideoFromRing(ringNum,file,resX,resY);
    end
    recordCompiledVideoFromRings(ringNumsToCompile,file);
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

function fileName = grabThisFileFromCamera(cameraName,file)
    fileName = ['\\10.19.2.139\Public\' cameraName '\' file '.mp4'];
end

function recordVideoFromRing(ringNum,file,resX,resY)
    vidObjectList = {};
    successfullyLoaded = [false false false false false];
    camNums = [4 5 1 2 3];
    for i = 1:length(camNums)
        num = ringNum*10+camNums(i);
        try
            vidObjectList{i} = VideoReader(grabThisFileFromCamera(getCameraName(num),file));
            disp(['Successfully loaded file for camera ' num2str(num)])
            successfullyLoaded(i) = true;
        catch
            disp(['Failed to load camera ' num2str(num)])
            successfullyLoaded(i) = false;
        end
    end
    if length(vidObjectList)==0
        error('no videos found for this video and this trial')
    end
    videoName = ['ring' num2str(ringNum) '_' file];
    recordATempVideoFromCameras(vidObjectList,successfullyLoaded,videoName,resX,resY,camNums);
end

function recordATempVideoFromCameras(vidObjectList,successfullyLoaded,videoName,resX,resY,camNums)
    fileName = ['C:\Users\User\Desktop\outputFiles\tempVideos\tempVideo_' videoName '.avi'];
    if isfile(fileName)
        delete(fileName)
    end

    v = VideoWriter(fileName);
    open(v);
    
    frame = uint8(zeros(resY,resX*5));
    emptyFrame = uint8(zeros(resY,resX));
    scale = 4;
    tic
    frameCount = 0;
    stillFrames = true;
    while(stillFrames)
        frameCount = frameCount+1;
%         if frameCount>1000
%             break;
%         end
        for i = 1:length(vidObjectList)
            if successfullyLoaded(i)
                %if fail to load frame, be done
                try
                    newFrame = rgb2gray(readFrame(vidObjectList{i}));
                catch
                    stillFrames = false;
                end
                %flip 4 or 5 cameras
                if camNums(i) == 4 || camNums(i) == 5
                    newFrame = flip(flip(newFrame)')';
                end
                frame(:,(i-1)*resX+1:resX*i) = newFrame;
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

    v = VideoWriter(['C:\Users\User\Desktop\outputFiles\Compiled_' file '.avi']);
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