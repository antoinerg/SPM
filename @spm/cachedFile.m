function [path_cached_file,cached_filename] = cachedFile(spm)
%cachedFile Gives path to cached file along with its filename
%Looks in the configuration file and compute the path of the cached file
%(whether it exists or not).

cfg=SPM.config;
cached_filename = [spm.Hash '.mat'];

if is_absolute(cfg.Caching.Folder)
    path_cached_file = fullfile(cfg.Caching.Folder,cached_filename);
else
    path_cached_file = fullfile(spm.Directory,cfg.Caching.Folder,cached_filename);
end

    function bool=is_absolute(path)
        % Might not be super robust (not tested on Windows)
        if path(1) == '/' || path(2) == ':'
            bool = true;
        else
            bool = false;
        end
    end

end
