
% Script with all the anonymous functions to send settings to cameras

%% commands
startRecording = @(url) urlread(['http://' url '/control/startRecording']);
stopRecording = @(url) urlread(['http://' url '/control/stopRecording']);
stopSaving = @(url) webwrite(['http://' url '/control/stopFilesave']);
saveToSmbDefaultName = @(url) webwrite(['http://' url '/control/startFilesave'],'format','h264','device','smb');

setFrameRate = @(url) webwrite(['http://' url '/control/p'],'frameRate','1000');


%% IO Settings 
options = weboptions('HeaderFields',{'Content-Type' 'application/json'});
purl = @(url) ['http://' url '/control/p'];

setIOToggleSet = @(url) webwrite(purl(url),struct('ioMappingToggleSet', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOCombOr2 = @(url) webwrite(purl(url),struct('ioMappingCombOr2', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOCombOr3 = @(url) webwrite(purl(url),struct('ioMappingCombOr3', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOStopRec = @(url) webwrite(purl(url),struct('ioMappingStopRec', struct('source', 'none', 'debounce', false, 'invert', false)),options);

setIOThresh2 = @(url) webwrite(purl(url),struct('ioThresholdIo2', '2.49929'),options);
setIOThresh1 = @(url) webwrite(purl(url),struct('ioThresholdIo1', '2.49929'),options);
setExposure = @(url) webwrite(purl(url),struct('exposureMode', 'normal'),options);

inputSettingFunctions = {setIOToggleSet;
                         setIOThresh2};


