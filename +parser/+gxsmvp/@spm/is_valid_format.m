function bool = is_valid_format(filename)
% Tells whether it is a GXSM vector probe file

a=findstr(filename,'.vpdata');

bool=a & true; 
end
