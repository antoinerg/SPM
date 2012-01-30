function Delete(spm)
%Delete Remove the cached version of the file
%Obejct remains in memory but is deleted from hard drive. This is a
%concern for those of you who store computationaly expensive data in
%UserChannel
[path_cached_file,cached_filename] = spm.cachedFile;
delete(path_cached_file);
disp('Cache deleted');
end