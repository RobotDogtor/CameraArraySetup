
% Script with all the anonymous functions to send settings to cameras

%urlread('http://10.19.2.102/control/p/externalStorage')

%% commands
startRecording = @(url) urlread(['http://' url '/control/startRecording']);
stopRecording = @(url) urlread(['http://' url '/control/stopRecording']);
stopSaving = @(url) urlread(['http://' url '/control/stopFilesave']);
saveToSmbDefaultName = @(url) webwrite(['http://' url '/control/startFilesave'],'format','h264','device','smb'); % deprecated
setDigitalGainTo6Db = @(url) webwrite(['http://' url '/control/p'],'digitalGain','2');
setAnalogGainTo0Db = @(url) webwrite(['http://' url '/control/p'],'analogGain','1');

setFrameRate = @(url) webwrite(['http://' url '/control/p'],'frameRate','1000');
setOverlayEnable = @(url) webwrite(['http://' url '/control/p'],'overlayEnable',true);

startBlackCalibration = @(url) webwrite(['http://' url '/control/startCalibration'],'blackCal',true);

%% IO Settings 
options = weboptions('HeaderFields',{'Content-Type' 'application/json'});
purl = @(url) ['http://' url '/control/p'];

setIOCombOr1 = @(url) webwrite(purl(url),struct('ioMappingCombOr1', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOCombOr2 = @(url) webwrite(purl(url),struct('ioMappingCombOr2', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOCombOr3 = @(url) webwrite(purl(url),struct('ioMappingCombOr3', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOCombXor = @(url) webwrite(purl(url),struct('ioMappingCombXor', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOCombAnd = @(url) webwrite(purl(url),struct('ioMappingCombAnd', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOGate = @(url) webwrite(purl(url),struct('ioMappingGate', struct('source', 'none', 'debounce', false, 'invert', false)),options);

setIOTrigger = @(url) webwrite(purl(url),struct('ioMappingTrigger', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOStopRec_Follower = @(url) webwrite(purl(url),struct('ioMappingStopRec', struct('source', 'io1', 'debounce', true, 'invert', true)),options);
setIOStartRec_Follower = @(url) webwrite(purl(url),struct('ioMappingStartRec', struct('source', 'io1', 'debounce', true, 'invert', false)),options);
setIOStopRec_Leader = @(url) webwrite(purl(url),struct('ioMappingStopRec', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOStartRec_Leader = @(url) webwrite(purl(url),struct('ioMappingStartRec', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOToggleFlip = @(url) webwrite(purl(url),struct('ioMappingToggleFlip', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOToggleClear = @(url) webwrite(purl(url),struct('ioMappingToggleClear', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOToggleSet = @(url) webwrite(purl(url),struct('ioMappingToggleSet', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIODelay = @(url) webwrite(purl(url),struct('ioMappingDelay', struct('source', 'none', 'debounce', false, 'invert', false)),options);
setIOShutter = @(url) webwrite(purl(url),struct('ioMappingShutter', struct('source', 'none', 'debounce', false, 'invert', false)),options);

setIO1_Follower = @(url) webwrite(purl(url),struct('ioMappingIo1', struct('drive',0,'source', 'none', 'debounce', false, 'invert', false)),options);
setIO1_Leader = @(url) webwrite(purl(url),struct('ioMappingIo1', struct('drive',2,'source', 'recording', 'debounce', true, 'invert', false)),options);
setIO2 = @(url) webwrite(purl(url),struct('ioMappingIo2', struct('drive',0,'source', 'none', 'debounce', false, 'invert', false)),options);

setIOThresh1 = @(url) webwrite(purl(url),struct('ioThresholdIo1', 0.5),options);
setIOThresh1_5 = @(url) webwrite(purl(url),struct('ioThresholdIo1', 2.5),options);
setIOThresh2 = @(url) webwrite(purl(url),struct('ioThresholdIo2', 2.49929),options);
setIODelayTime = @(url) webwrite(purl(url),struct('ioDelayTime', 0.499999),options);

setExposure = @(url) webwrite(purl(url),struct('exposureMode', 'normal'),options);
setCurrentGain = @(url) webwrite(purl(url),struct('currentGain', 1.375),options);
setRecTrigDelay = @(url) webwrite(purl(url),struct('recTrigDelay', 0),options);
setRecPreBurst = @(url) webwrite(purl(url),struct('recPreBurst', 1),options);

inputSettingFunctionsFollower = {setIOCombOr1;
                         setIOCombOr2;
                         setIOCombOr3;
                         setIOCombXor;
                         setIOCombAnd;
                         setIOGate;
                         setIOTrigger;
                         setIOStopRec_Follower;
                         setIOStartRec_Follower;
                         setIOToggleFlip;
                         setIOToggleClear;
                         setIOToggleSet;
                         setIODelay;
                         setIOShutter;
                         setIO1_Follower;
                         setIO2;
                         setIOThresh1;
                         setIOThresh2;
                         setIODelayTime};


inputSettingFunctionsLeader = {setIOCombOr1;
                         setIOCombOr2;
                         setIOCombOr3;
                         setIOCombXor;
                         setIOCombAnd;
                         setIOGate;
                         setIOTrigger;
                         setIOStopRec_Leader;
                         setIOStartRec_Leader;
                         setIOToggleFlip;
                         setIOToggleClear;
                         setIOToggleSet;
                         setIODelay;
                         setIOShutter;
                         setIO1_Leader;
                         setIO2;
                         setIOThresh1;
                         setIOThresh2;
                         setIODelayTime};
% 'alwaysHigh'
% 'io1' drive 2

%% Shutter settings

