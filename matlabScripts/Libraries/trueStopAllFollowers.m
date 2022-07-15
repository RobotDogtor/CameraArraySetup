function trueStopAllFollowers()
    URLs = getAllCameraURLs();
    for i = 1:length(URLs)
        try
            trueStopFollower(URLs{i})
        catch
            disp(['camera ' URLs{i} ' could not be stopped.'])
        end
    end
end
