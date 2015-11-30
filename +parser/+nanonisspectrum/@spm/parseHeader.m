function parseHeader(nspectrum)
% Parse header and store metadata into object

% Open the file
fid = fopen(nspectrum.Path,'r');

%Set flags
eof=0;header_end=0;

    % Loop through the header
    while (~header_end)
        line=fgets(fid);
        
        % Reach end of header
        if (findstr('[DATA]',line)), header_end  = 1;continue; end

        nspectrum.Header = addToHeader(nspectrum.Header,line);
    end
    
    % Load column headers  
    line=fgets(fid);
    C=textscan(line,'%s','Delimiter','\t');
    C=C{1};
    for i=1:length(C)
        ch=SPM.parser.nanonisspectrum.channel(nspectrum);
        s=regexp(C{i},'(.*) \((.*)\)','tokens');
        if findstr('[bwd]',C{i})
            ch.Direction='Backward';
        end
        ch.Name=strrep(s{1}{1},' [bwd]',''); % Name
        ch.Units=s{1}{2}; % Units
        ch.id=i; % id
        nspectrum.Channel=cat(1,nspectrum.Channel,ch); % Append to the cell of channels
    end
fclose(fid);

nspectrum.Width=0;
nspectrum.Height=0;
nspectrum.Type=nspectrum.Header.experiment;
% nspectrum.Header.date = 02.11.2011 11:17:24
d=datenum(nspectrum.Header.date,'dd.mm.yyyy HH:MM:SS');
nspectrum.Date=datestr(d,'yyyy-mm-ddTHH:MM:SS');
end

%%%%
%
%   FUNCTIONS
%
%%%%
function header=addToHeader(header,line)
    % Separate name from value
    C=textscan(line,'%s%s','Delimiter','\t');
    
    if ~isempty(C{1})
        % Read the name and sanitize
        name=C{1}{1};
        name=regexprep(lower(name), '[^a-z0-9_]', '_');
        name=strtrim(name);
        
        %substr={' ','>','(',')','-','/','.','^'};
        %for i=1:length(substr)
        %    name=strrep(name,substr{i},'');
        %end


        % Read attr    
        attr=C{2}{1};
        header.(name)=attr;
    else
        header;
    end
end
