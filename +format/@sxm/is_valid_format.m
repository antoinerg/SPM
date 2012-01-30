function bool = is_valid_format(filename)
%Tells you whether the file is sxm or not
a=0;b=0;
try
    a=findstr(filename,'.sxm');
    fid = fopen(filename,'r');
    
    % check whether file is a Nanonis data file.
    
    s=fgetl(fid);
    if ~strcmp(s, ':NANONIS_VERSION:')
        b=0;
    else
        b=1;
    end
    
    fclose(fid);
catch err
    
end
bool = a & b;
end