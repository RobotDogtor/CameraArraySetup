

x = '{ "source": "none", "debounce": false, "invert": false }';
x = { 'source', 'none', 'debounce', false, 'invert', false };

% 192.168.12.1 is the IP address of a camera when connected via USB.
cameraURL = 'http://10.19.2.101/control/p';

% Set Content-Type using HeaderFields instead of MediaType
% to avoid having a semicolon after json in CharacterEncoding,
% which would cause Error 400 Bad Request.
options = weboptions('HeaderFields',{'Content-Type' 'application/json'});

% When setting parameters inside another parameter, they should be nested.
toggleSetStructIn = struct('source', 'none', 'debounce', false, 'invert', false);
toggleSetStruct = struct('ioMappingToggleSet', toggleSetStructIn);

% Change resolution via an HTTP POST request.
response = webwrite(cameraURL,toggleSetStruct,options);

urlread('http://10.19.2.101/control/p/externalStorage')


%%

dataInside = struct('device', '//10.19.2.127/public/camera01', 'description', 'SMB Share', 'mount', '/media/smb', 'fstype', 'cifs');
dataOutside = struct('smb', dataInside);
dataOOOOOut = struct('externalStorage', dataOutside);
% Change resolution via an HTTP POST request.
response = webwrite(cameraURL,dataOOOOOut,options);

urlread('http://10.19.2.101/control/p/externalStorage')
