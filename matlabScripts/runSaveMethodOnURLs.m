function runSaveMethodOnURLs(URLs)
    %   Method to run an anonymous function on all the provided URLs
    currDateTime = char(datetime('now'));
    currDateTime = strrep(currDateTime,' ','_');
    currDateTime = strrep(currDateTime,':','-');
    for i = 1:length(URLs) 
       webwrite(['http://' URLs{i} '/control/startFilesave'],'format','h264','device','smb','filename',['Video_' currDateTime]);    
    end
end

