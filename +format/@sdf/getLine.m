function getLine(sdf)
% Open the file
fid = fopen(sdf.Path,'r');

%Set flags
eof=0;

%Get info about our channel
L=length(sdf.Channel);

% Loop through the file
nb=0;
while (~eof)
    line=fgets(fid);
    
    if (findstr('<env r="0">',line))
        nb=nb+1;
    end
  
    if( (-1)==line ) eof  = 1; end % End of file condition
end
fclose(fid);

sdf.Line = nb;
end