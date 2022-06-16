clear
clc


% status = urlread('http://10.19.2.200/control/startRecording','get','{}');
% pause(2);
% status = urlread('http://10.19.2.200/control/stopRecording','post','');
% 
% 
% imshow(rgb2gray(imread('http://10.19.2.200/cgi-bin/screenCap?')))
% 
% 
% /control/startFilesave

% web('http://10.19.2.200')

urlread('http://10.19.2.105/control/p/config')


%% 


cameraURL = 'http://10.19.2.200/control/startFilesave';
options = weboptions('MediaType','application/json');
% response = webwrite(cameraURL,'format','h264','device','smb','start',0,'length',500);
response = webwrite(cameraURL,'format','h264','device','smb');

%%

cameraURL = 'http://10.19.2.200/control/p';
response = webwrite(cameraURL,'frameRate','1000');

%%

response = webwrite(cameraURL,'ioMappingToggleSet','{ "source": "none", "debounce": false, "invert": false }');
response = webwrite(cameraURL,'ioMappingToggleSet:source','none');