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
                webwrite(['http://10.19.2.1' additionalZero num2str(num) '/control/startFilesave'],'format','h264','device','smb','filename',fileName);
            catch
                disp(['camera ' num2str(num) ' could did not start saving.'])
            end
        end
    end
end