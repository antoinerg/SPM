function getPointsPerLine(sdf)
% Open the file
fid = fopen(sdf.Path,'r');

%Set flags
eof=0;

%Get info about our channel
L=length(findobj(sdf.Channel,'Direction','Forward'));

% Loop through the file
byte_location=zeros(2);
while (~eof)
    line=fgets(fid);
    
    if (findstr('<env r="0">',line))
        byte_location(1)=ftell(fid);
    end
    
    if (findstr('</env>',line))
        byte_location(2)=ftell(fid);
        eof=1;
    end
    
    if( (-1)==line ) eof  = 1; end % End of file condition
end
fclose(fid);

% Simple calculation of the number of bytes minus 10 to account for the
% '</env>' and newline characters we read which are not data
bytes_of_data=byte_location(2)-byte_location(1)-10;

%Each points use 4 bytes per channel plus one delimiter byte
nb=bytes_of_data/(4*L+1); 

sdf.PointsPerLine = nb;
end