clear
clc

%% find problem cameras
%     imshow(rgb2gray(imread('http://10.19.2.102/cgi-bin/screenCap')))
URLs = getAllCameraURLs();
numCameras = length(URLs);

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