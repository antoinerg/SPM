function parseHeader(n5)
% Parse header and store metadata into object

% Metadata

header(1).label='Scanner type:';
header(2).label='Scan size:';
header(3).label='Lines:';
header(4).label='Samps';

metadata=read_header_values(n5.Path,header);

n5.Type = metadata(1).values;
n5.Width = metadata(2).values{1};
n5.Height = metadata(2).values{1};
n5.Lines = metadata(3).values{1};
n5.PointsPerLine = metadata(4).values{1};

% Get channel info

header(1).label='@2:Z scale:';
header(2).label='Data offset';
header(3).label='Image Data:';
header(4).label='Line direction:';
header(5).label='@Sens. Zscan:';

params=read_header_values(n5.Path,header);

scaling       = params(1).values; %Scaling parameters
image_pos     = params(2).values; %Data position
z_sensitivity = params(5).values; %Z sens
L=length(image_pos);

for i=1:L
   ch=SPM.parser.nanoscope5.channel(n5);
   ch.Name=params(3).values{i};
   ch.Direction='Forward';
   ch.pos=image_pos{i};
   ch.scaling=scaling{i};
   ch.zsens=z_sensitivity{1};
   n5.Channel=cat(1,n5.Channel,ch); % Append to the cell of channels
end

end

%%%%
%
%   FUNCTIONS
%
%%%%

% Function to parse the headers
function [parameters] = read_header_values(filename, header_strings)
% Open the file
fid = fopen(filename,'r');

% Set flags
header_end=0;eof=0;counter=1;byte_location=0;

nstrings=size(header_strings,2);
for i=1:nstrings
    parcounter(i)=1;
    parameters(i).values={};
end;

% Loop through header and line number of the searched string
while( and( ~eof, ~header_end ) )
    
    byte_location = ftell(fid);
    line = fgets(fid);
    
    for i=1:nstrings
        if findstr(header_strings(i).label,line)
            if (SPM.parser.nanoscope5.spm.extract_number(line))
                b=findstr('LSB',line);
                if (b>0)
                    parameters(i).values(parcounter(i))={SPM.parser.nanoscope5.spm.extract_number(line(b(1):end))};
                else
                    parameters(i).values(parcounter(i))={SPM.parser.nanoscope5.spm.extract_number(line)};
                end;
            else
                b= findstr(line,'"');
                c= findstr(line,':');
                if (b>0)
                    parameters(i).values(parcounter(i))={line(b(1)+1:b(2)-1)};
                elseif (c>0)
                    parameters(i).values(parcounter(i))={strtrim(line(c(1)+1:end))};
                end;
            end;
            parcounter(i)=parcounter(i)+1;
        end
        
        if( (-1)==line ) eof  = 1; end % End of file condition
        if length( findstr(line,'\*File list end')) header_end = 1; end % End of header section condition
        
    end
end

fclose(fid);
end
