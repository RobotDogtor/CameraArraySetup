function runSaveMethodOnURLs(URLs)
    %   Method to run an anonymous function on all the provided URLs
    currDateTime = char(datetime('now'));
    currDateTime = strrep(currDateTime,' ','_');
    currDateTime = strrep(currDateTime,':','-');
    for i = 1:length(URLs) 
        try
            webwrite(['http://' URLs{i} '/control/startFilesave'],'format','h264','device','smb','filename',['Video_' currDateTime]);  
        catch
            disp(['Saving All Cameras: camera ' URLs{i} ' could did not start saving.'])
        end
    end
    % response = webwrite(cameraURL,'format','h264','device','smb','start',0,'length',500);
end

