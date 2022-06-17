function runMethodOnURLs(URLs,method)
%   Method to run an anonymous function on all the provided URLs
% input is a cell array of URL strings
    for i = 1:length(URLs) 
        method(URLs{i}); 
    end
end