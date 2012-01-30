function loadRawData(nsch)
% Get handle of the parent sdf object
ns=nsch.spm;
% Open the file
fid = fopen(ns.Path,'r','ieee-be');

%Set flags
eof=0;

%Get info about our channel
L=length(ns.Channel);

rawData=[];

% Loop through the file
%Set flags
eof=0;header_end=0;

    % Loop through the header
    while (~header_end)
        line=fgets(fid);
        
        % Reach end of header
        if (findstr('[DATA]',line)), header_end  = 1;continue; end
    end
    line=fgets(fid);
    
    while (~eof)
        line=fgets(fid);
        if( (-1)==line ), eof  = 1;continue; end % End of file condition
        C=textscan(line,'%f','Delimiter','\t');
        C=C{1};
        rawData=cat(1,rawData,C(nsch.id));

    end
    fclose(fid);

nsch.rawData=rawData;
end