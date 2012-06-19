function parseHeader(n5)
% Parse header and store metadata into object

% Metadata

header(1).label='Scanner type:';
header(2).label='Scan size:';
header(3).label='Lines:';
header(4).label='Samps';
header(5).label='Date:';

metadata=read_header_values(n5.Path,header);

n5.Type = metadata(1).values{1};
n5.Width = metadata(2).values{1};
n5.Height = metadata(2).values{1};
n5.Lines = metadata(3).values{1};
n5.PointsPerLine = metadata(4).values{1};

% Transform date into DateTime format
match=regexp(metadata(5).values{1},'(?<time>\d\d:\d\d:\d\d [AP]M) \w{3} (?<date>\w{3} \d\d \d{4})','names');
n5.Date=datestr(datenum([match.time match.date]),'yyyy-mm-ddTHH:MM:SS');

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

% Function to extract value
function value = extract_value(str)
b= findstr(str,'"');
c= findstr(str,':');
if (b>0)
    value={str(b(1)+1:b(2)-1)};
elseif (c>0)
    value={strtrim(str(c(1)+1:end))};
end;
end

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

% Loop through header and str number of the searched string
while( and( ~eof, ~header_end ) )
    
    byte_location = ftell(fid);
    str = fgets(fid);
    
    for i=1:nstrings
        if findstr(header_strings(i).label,str)
            if (strcmp(header_strings(i).label,'Date:'))
                parameters(i).values(parcounter(i))=extract_value(str);
            elseif (SPM.parser.nanoscope5.spm.extract_number(str))
                b=findstr('LSB',str);
                if (b>0)
                    parameters(i).values(parcounter(i))={SPM.parser.nanoscope5.spm.extract_number(str(b(1):end))};
                else
                    parameters(i).values(parcounter(i))={SPM.parser.nanoscope5.spm.extract_number(str)};
                end;
            else
                parameters(i).values(parcounter(i))=extract_value(str);
            end;
            parcounter(i)=parcounter(i)+1;
        end
        
        if( (-1)==str ) eof  = 1; end % End of file condition
        if length( findstr(str,'\*File list end')) header_end = 1; end % End of header section condition
        
    end
end

fclose(fid);
end
