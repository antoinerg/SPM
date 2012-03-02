function bool=is_valid_format(path)
% Check if file is raw SDF
try
    test=SPM.parser.sdf.spm(path);
    bool=true;
    return;
catch
    bool=false;
    return;
end

end
