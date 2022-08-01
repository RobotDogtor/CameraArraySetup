clear
clc


load("CameraPoints.mat")

numCameras = 20;
numPoints = 8000;
Ws = zeros(3*numCameras,numPoints);
IdMat = zeros(numCameras,numPoints);

for i = 1:numPoints
    for j = 1:numCameras
        Ws(j*3-2,i) = Cameras(j).CameraXpoints(i)*1024;
        Ws(j*3-1,i) = Cameras(j).CameraYpoints(i)*1280;
        if isnan(Cameras(j).CameraXpoints(i)) || isnan(Cameras(j).CameraYpoints(i))
            Ws(j*3,i) = nan;
            IdMat(j,i) = 0;
        else
            Ws(j*3,i) = 1;
            IdMat(j,i) = 1;
        end

    end
end

for i = 1:numPoints
    goodPoints(i) = sum(IdMat(:,i)) == 5 || sum(IdMat(:,i)) == 6 || sum(IdMat(:,i)) == 7;
end

%%
j = 18;
plot(Cameras(j).CameraXpoints,Cameras(j).CameraYpoints,'ro')
axis([0 1 0 1])

%%
% goodPoints = (sum(IdMat) == 5) + (sum(IdMat) == 6);% + (sum(IdMat) == 7) + (sum(IdMat) == 4);
Ws = Ws(:,goodPoints);
IdMat = IdMat(:,goodPoints);

%% Check all Cameras have points, chack each pair has 8 points
sum(~isnan(Ws(54,:)))


%%
save('TestData/CameraPointsWS.mat','Ws')
save('TestData/points','Ws')
save('TestData/IdMat','IdMat')