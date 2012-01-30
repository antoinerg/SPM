function bool = is_valid_format(filename)
%IS_NANOSCOPE5 Tells you whether the file is nanoscope5 or not
a=0;b=0;
try
    fid = fopen(filename,'r');
    
    line=fgets(fid);
    a=findstr('\*File list',line);
    line=fgets(fid);
    b=findstr('\Version: 0x05120005',line);
    
    fclose(fid);
catch err
end

bool = and(a,b);
end

