function runSaveMethodOnRings(ringNums,fileName)

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
                start_frame=str2double(start_frame(22:25))-8000;    % added by  on Aug 23
                webwrite(['http://10.19.2.1' additionalZero num2str(num) '/control/startFilesave'],'format','h264','device','smb','start',start_frame,'length',8000,'filename',fileName);   % added by Abhradeep on Aug 23
                disp(['camera ' num2str(num) ' started saving.'])
            catch
                disp(['camera ' num2str(num) ' could not start saving.'])
            end
        end
    end
end