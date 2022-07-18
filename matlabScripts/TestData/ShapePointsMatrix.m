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
    goodPoints(i) = sum(IdMat(:,i)) == 5 || sum(IdMat(:,i)) == 6;
end
% goodPoints = (sum(IdMat) == 5) + (sum(IdMat) == 6);% + (sum(IdMat) == 7) + (sum(IdMat) == 4);
Ws = Ws(:,goodPoints);
IdMat = IdMat(:,goodPoints);

save('CameraPointsWS.mat','Ws')
save('points','Ws')
save('IdMat','IdMat')