function runMethodOnURLs(URLs,method)
%   Method to run an anonymous function on all the provided URLs
    for i = 1:length(URLs) 
        method(URLs{i}); 
    end
end