function loadRawData(sfch)
% Get handle of the parent sdf object
sdf=sfch.spm;
% Open the file
fid = fopen(sdf.Path,'r');

%Set flags
eof=0;

%Get info about our channel
L=length(findobj(sdf.Channel,'Direction','Forward'));
pointDataSize=4*(L-1)+1;

%Prepare to record the right direction
switch(sfch.Direction)
    case 'Forward'
        match_string='r="0"';
    case 'Backward'
        match_string='r="1"';
end

rawData=[];

% Loop through the file
while (~eof)
    line=fgets(fid);
    if (findstr(match_string,line))
        % Skip the magic byte which acts as a point delimiter
        fseek(fid,1,0);
        
        % Move to our channel's bytes within the point
        fseek(fid,(L-sfch.pos)*4,0);
        
        % Read our data at fixed interval
        points=fread(fid,[1 sdf.PointsPerLine],'int32',pointDataSize,'l');
        fseek(fid,-pointDataSize,0);
        rawData=cat(1,rawData,points);
    end
    
    if( (-1)==line ), eof  = 1; end % End of file condition
end
fclose(fid);

sfch.rawData=rawData;
end