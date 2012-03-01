function parseHeader(sf)
% Parse header and store metadata into object

% Open the file
fid = fopen(sf.Path,'r');

%Set flags
eof=0;

% Loop through the file
while (~eof)
    %byte_location=ftell(fid);
    line=fgets(fid);
    
    % Get date and type
    if (findstr('<datastream',line))
        [xml name attr] = SPM.format.sdf.parseXMLline(line);
        sf.Date=attr.date;
        sf.Type=attr.type;
    end
   
    % Get channel
    getChannel(sf,line)
    
    % Reach end of header
    if (findstr('<env r="0">',line)), eof  = 1; end
    
    % Reach end of file
    if( (-1)==line )
        eof  = 1;
        % If we reach EOF, file format is not SDF otherwise end of
        % header would have been met.
        MException('Not a proper SDF');
    end
end

fclose(fid);

sf.Width = sf.Channel(1).d1 - sf.Channel(1).d0;
sf.Height = sf.Channel(2).d1 - sf.Channel(2).d0;
end

%%%%
%
%   FUNCTIONS
%
%%%%

function getChannel(sf,line)
    % Popuplate the 'Channel' array
    if (findstr('channel',line))
        [xml name attr]=SPM.format.sdf.parseXMLline(line);
        % Forward channel
        ch=SPM.format.sdfchannel(sf);
        ch.Name=attr.name; % Name
        ch.Units=attr.unit; % Units
        ch.id=attr.id; % id
        ch.pos=length(findobj(sf.Channel,'Direction','Forward'))+1; % pos
        ch.Direction='Forward';
        sf.Channel=cat(1,sf.Channel,ch); % Append to the cell of channels
        
        % Backward channel
        ch=SPM.format.sdfchannel(sf);
        ch.Name=attr.name; % Name
        ch.Units=attr.unit; % Units
        ch.id=attr.id; % id
        ch.pos=length(findobj(sf.Channel,'Direction','Backward'))+1; % pos
        ch.Direction='Backward';
        sf.Channel=cat(1,sf.Channel,ch); % Append to the cell of channels
    end
    
    % Get our channel's range when we encounter the span
    % element
    if (findstr('span',line))
        [xml name attr]=SPM.format.sdf.parseXMLline(line);
        % Find the associated channel
        ch=sf.getChannelById(attr.c);
        for i=1:length(ch)
            ch(i).n0=sscanf(attr.n0,'%f');
            ch(i).n1=sscanf(attr.n1,'%f');
            ch(i).d0=sscanf(attr.d0,'%f');
            ch(i).d1=sscanf(attr.d1,'%f');
        end
    end

end
