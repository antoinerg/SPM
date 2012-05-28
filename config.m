function s=config

%%%%
%   FORMAT
%%%%
s.Format = {'nanoscope5','sdf','nanonisspectrum','sxm','gxsmvp'};

%%%%
%   USER POSTPROCESSING FUNCTIONS
%%%%
s.UserFunctions = {'Fit(channel,name)'};

%%%%
%   CACHING
%%%%
s.CachingEnabled = false;
% Prefix given to cached filename
s.Caching.Filename.Extension = '.mat';
s.Caching.CachingFolder = '/Users/antoine/tmp'; % either an absolute path or relative path from parent directory of the file
end
