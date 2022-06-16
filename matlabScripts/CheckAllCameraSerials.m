clear
clc


URLs = {'10.19.2.101';
        '10.19.2.102';
        '10.19.2.103';
        '10.19.2.104';
        '10.19.2.105'};

for i = 1:4
    cameraIP = URLs{i};
    result = urlread(['http://' cameraIP '/control/p/dateTime']);
%     result(5:29)
    result(1:end)
end

urlread('http://10.19.2.101/control/p/externalStorage');