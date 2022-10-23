function runSaveMethodOnRings(ringNums,fileName)
        
    total_frames_to_save=1500; % 8732 -change this according to make equal to totalFrames as shown by CheckSavedFrameNum.m
    for ringNum = ringNums
        for i = 1:5
            num = ringNum*10+i;
            
            if num<10
                additionalZero = '0';
            else 
                additionalZero = '';
            end
            
            try
                %  webwrite(['http://10.19.2.121/control/startFilesave'],'format','h264','device','smb','filename',fileName);
                % webwrite(['http://10.19.2.1' additionalZero num2str(num) '/control/startFilesave'],'format','h264','device','smb','filename',fileName);    % removed by Abhradeep on Aug 23
                start_frame=urlread(['http://10.19.2.1' additionalZero num2str(num) '/control/p/totalFrames']);   % added by abhradeep on Aug 23
                start_frame=str2double(start_frame(22:25))-total_frames_to_save;    % added by abhradeep on Aug 23 - 8000 should be replaced by min of frames saved across all cameras
                webwrite(['http://10.19.2.1' additionalZero num2str(num) '/control/startFilesave'],'format','h264','device','smb','start',start_frame,'length',total_frames_to_save,'filename',fileName);   % added by Abhradeep on Aug 23
                disp(['camera ' num2str(num) ' started saving.'])
            catch
                disp(['camera ' num2str(num) ' could not start saving.'])
            end
        end
    end
end