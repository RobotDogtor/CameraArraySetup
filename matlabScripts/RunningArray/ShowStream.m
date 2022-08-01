clear
clc
close all

%% setup
URLs = getAllCameraURLs();
numCameras = length(URLs);
sc = 1/4;

%setup the full, compiled frame       imshow(rgb2gray(imread('http://10.19.2.102/cgi-bin/screenCap')))
url = ['http://' URLs{5} '/cgi-bin/screenCap?' num2str(rand)] ;
thisFrame  = rgb2gray(imread(url));
xdimSize = length(thisFrame(1,:));
ydimSize = length(thisFrame(:,1));

frame = [];
frameX = [];
emptyFramePart = thisFrame(1:1/sc:end,1:1/sc:end)*0;
for i = 1:10
    frameX = [frameX emptyFramePart];
end
for i = 1:5
    frame = [frame; frameX];
end


%% find problem cameras
problemi = [];

for i = 1:numCameras
    url = ['http://' URLs{i} '/cgi-bin/screenCap'] ;
    try
        x = imread(url);
    catch
        problemi = [problemi i];
    end
    disp(i)
end

disp('Problem URLs')
for j = problemi
    disp(['     ' URLs{j}])
end

%% loop stream
figure(1)
while(1)
    for i = 1:numCameras
        xpos = mod(i,10);
        ypos = (i - mod(i,10))/10 + 1;
        if xpos == 0
            xpos = 10;
            ypos = ypos-1;
        end
%         disp([xpos ypos])

        xrange = (xpos-1)*xdimSize*sc+1:xpos*xdimSize*sc;
        yrange = (ypos-1)*ydimSize*sc+1:ypos*ydimSize*sc;

        %if the camera is not working then it will do an empty frame
        isProblem = false;
        for m = problemi
            if i == m
                isProblem = true;
            end
        end

        if isProblem
            frame(yrange,xrange) = emptyFramePart;
        else
            url = ['http://' URLs{i} '/cgi-bin/screenCap'] ;
            thisFrame  = rgb2gray(imread(url));
            frame(yrange,xrange) = thisFrame(1:1/sc:end,1:1/sc:end);
        end
    end
    imshow(frame);
%     drawnow;
end
