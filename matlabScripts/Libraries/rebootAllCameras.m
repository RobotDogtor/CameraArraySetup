function rebootAllCameras()
    for r = 4:9
        for c = 1:5
            try
                rebootCamera(r*10+c);
            catch
                disp(['camera ' num2str(r*10+c) 'did not reboot'])
            end
        end
    end
end
