function bool=is_valid_format(path)
% Check if file is raw SDF
try
    test=SPM.format.sdf(path);
    bool=true;
    return;
catch
    bool=false;
    return;
end

end