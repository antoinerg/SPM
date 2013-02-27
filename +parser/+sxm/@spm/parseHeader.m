function parseHeader(sxm)
% Parse header and store metadata into object

% Open the file
fid = fopen(sxm.Path, 'r', 'ieee-be');    % open with big-endian

%Set flags
eof=0;header_end=0;

% First line is :NANONIS_VERSION:
line=fgetl(fid);

% get header
header.version = str2num(fgetl(fid));
read_tag = 1;

% read header data
% The header consists of key-value pairs. Usually the key is on one line, embedded in colons
% e.g. :SCAN_PIXELS:, the next line contains the value.
% Some special keys may have multi-line values (like :COMMENT:), in this case read value
% until next key is detected (line starts with a colon) and set read_tag to 0 (because key has
% been read already).
while 1
    if read_tag
        s1 = strtrim(fgetl(fid));
    end
    s1 = s1(2:length(s1)-1);    % remove leading and trailing colon
    read_tag = 1;
    switch s1
        % strings:
        case {'SCANIT_TYPE', 'REC_DATE', 'REC_TIME', 'SCAN_FILE', 'SCAN_DIR'}
            s2 = strtrim(fgetl(fid));
            header.(lower(s1)) = s2;
            % comment:
        case 'COMMENT'
            s_com = '';
            s2 = strtrim(fgetl(fid));
            while ~strncmp(s2, ':', 1)
                s_com = [s_com s2 char(13)];
                s2 = strtrim(fgetl(fid));
            end
            header.comment = s_com;
            s1 = s2;
            read_tag = 0;  % already read next key (tag)
            % Z-controller settings:
        case 'Z-CONTROLLER'
            header.z_ctrl_tags = strtrim(fgetl(fid));
            header.z_ctrl_values = strtrim(fgetl(fid));
            % numbers:
        case {'BIAS', 'REC_TEMP', 'ACQ_TIME', 'SCAN_ANGLE'}
            s2 = fgetl(fid);
            header.(lower(s1)) = str2num(s2);
            % array of two numbers:
        case {'SCAN_PIXELS', 'SCAN_TIME', 'SCAN_RANGE', 'SCAN_OFFSET'}
            s2=fgetl(fid);
            header.(lower(s1)) = sscanf(s2, '%f');
            % data info:
        case 'DATA_INFO'
            s = '';
            s2=strtrim(fgetl(fid));
            n=0;
            while length(s2)>2
                s = sprintf('%s\n%s', s, s2);
                s2 = strtrim(fgetl(fid));
                addToChannel(s2,n);
                n=n+1;
            end
            header.data_info = s;
        case 'SCANIT_END'
            break;
        otherwise % treat as strings
            s1 = regexprep(lower(s1), '[^a-z0-9_]', '_');
            s_line = strtrim(fgetl(fid));
            s2 = '';
            while ~strncmp(s_line, ':', 1)
                s2 = [s2 s_line char(13)];
                s_line = strtrim(fgetl(fid));
            end
            header.(s1) = s2;
            s1 = s_line;
            read_tag = 0;  % already read next key (tag)
    end
end

% \1A\04 (hex) indicates beginning of binary data
s1 = [0 0];
while s1~=[26 4]
    s2 = fread(fid, 1, 'char');
    s1(1) = s1(2);
    s1(2) = s2;
end

sxm.Header=header;
sxm.Width=header.scan_range(1)*1e9;
sxm.Height=header.scan_range(2)*1e9;
sxm.Date=header.rec_date;


    function addToChannel(str,pos)
        if ~(isempty(str))
            result=textscan(str,'%d %s %s %s %f %f');
            direction=result{4}{1};
            if strcmpi(direction,'both')
                ch_f=SPM.parser.sxm.channel(sxm);
                ch_b=SPM.parser.sxm.channel(sxm);
                ch_f.Name=result{2}{1}; % Name
                ch_f.Units=result{3}{1}; % Units
                ch_f.id=result{1}; % id
                ch_f.pos=pos*2;
                ch_b.Name=result{2}{1}; % Name
                ch_b.Units=result{3}{1}; % Units
                ch_b.id=result{1}; % id
                ch_b.pos=2*pos+1;
                ch_f.Direction='Forward';
                ch_b.Direction='Backward';
                sxm.Channel=cat(1,sxm.Channel,ch_f); % Append to the cell of channels
                sxm.Channel=cat(1,sxm.Channel,ch_b); % Append to the cell of channels
            end
        end
    end
        
        fclose(fid);
    end
