function bool = is_valid_format(filename)
%Tells you whether the file is nanonisspectrum or not
a=0;b=0;c=0;
try
    a=findstr(filename,'.dat');
    fid = fopen(filename,'r');
    
    line=fgets(fid);
    b=findstr('Experiment',line);
    line=fgets(fid);
    c=findstr('Date',line);
    
    fclose(fid);
catch err
end

bool = a & b & c;
end