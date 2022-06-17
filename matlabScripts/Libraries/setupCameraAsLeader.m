function setupCameraAsLeader(camurl)

    AnonFunLibrary

    runMethodOnURLs({camurl},stopRecording);
    
    for i = 1:length(inputSettingFunctionsLeader)
        runMethodOnURLs({camurl},inputSettingFunctionsLeader{i});
        disp(['set setting ' num2str(i) '/' num2str(length(inputSettingFunctionsLeader))]);
    end


end

